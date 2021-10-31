/**
 * Valence (https://valence.app) Adapter that knows how to interact with the Intacct API.
 */
global with sharing class IntacctAdapter implements valence.SourceAdapterForPull, valence.LazyLoadSchemaAdapter, valence.NamedCredentialAdapter, valence.SourceAdapterScopeSerializer, valence.ConfigurableSourceAdapter, valence.ConfigurableTargetAdapter, valence.TargetAdapter {

	private final static String INTACCT_DATE_FORMAT = 'MM/dd/yyyy HH:mm:ss';
	private final static String SERVER_TIMEZONE = 'America/New_York';

	@TestVisible
	private String SENDER_ID;
	@TestVisible
	private String SENDER_PASSWORD;
	@TestVisible
	private String COMPANY_ID;

	@TestVisible
	private String namedCredential;

	@TestVisible
	private TargetConfiguration targetConfig = new TargetConfiguration('RECORDNO', null); // default configuration

	// ----------------------------------
	// ----- NamedCredentialAdapter -----
	// ----------------------------------

	/**
	 * Here we are handed a NamedCredential to use by the Valence framework.
	 *
	 * @param namedCredential The NamedCredential name that we will use to connect to the API
	 */
	public void setNamedCredential(String namedCredential) {
		this.namedCredential = namedCredential;
	}

	// -------------------------
	// ----- SchemaAdapter -----
	// -------------------------

	/**
	 * Valence framework asking us to describe what tables are available for retrieval from SAP.
	 *
	 * @return A list of tables we can read from
	 */
	public List<valence.Table> getTables() {

		/*
		 * Call the List Object endpoint of the Intacct API to get details about which Objects are in the system.
		 */

		// set up our function
		IntacctFunction queryTables = new IntacctFunction('<inspect><object>*</object></inspect>', true);

		// call the API
		sendFunction(queryTables);

		// parse results
		List<valence.Table> tables = new List<valence.Table>();
		for(Dom.XmlNode objectNode : queryTables.responseData.getChildElements()) {
			tables.add(valence.Table.create(objectNode.getAttributeValue('typename', null))
				.withLabel(objectNode.getText())
				.setEditable(true)
				.build()
			);
		}
		return tables;
	}

	/**
	 * Valence framework asking for field-level information to understand the shape of what can be retrieved.
	 *
	 * @param tableName The specific table we want to get field information for
	 *
	 * @return A list of fields that can be retrieved on the given table
	 */
	public List<valence.Field> getFields(String tableName) {

		/*
		 * Call the details version of the List Object endpoint of the Intacct API to get field info about a particular object.
		 */

		// set up our function
		IntacctFunction fieldsFunction = new IntacctFunction('<lookup><object>' + tableName + '</object></lookup>', true);

		// call the API
		sendFunction(fieldsFunction);

		Dom.XmlNode objectDefinition = fieldsFunction.responseData.getChildElement('Type', null);

		return parseFields(objectDefinition);
	}

	private List<valence.Field> parseFields(Dom.XmlNode objectDefinition) {

		List<valence.Field> fields = new List<valence.Field>();

		// get all field definitions
		for(Dom.XmlNode fieldNode : objectDefinition.getChildElement('Fields', null).getChildElements()) {
			fields.add(valence.Field.create(fieldNode.getChildElement('ID', null).getText())
				.withLabel(fieldNode.getChildElement('LABEL', null).getText())
				.withDescription(fieldNode.getChildElement('DESCRIPTION', null).getText())
				.withType(fieldNode.getChildElement('DATATYPE', null).getText())
				.setRequired('true'.equalsIgnoreCase(fieldNode.getChildElement('REQUIRED', null).getText()))
				.setEditable('false'.equalsIgnoreCase(fieldNode.getChildElement('READONLY', null).getText()))
				.build()
			);
		}

		// get all relationship definitions
		for(Dom.XmlNode fieldNode : objectDefinition.getChildElement('Relationships', null).getChildElements()) {
			fields.add(valence.Field.create(fieldNode.getChildElement('OBJECTPATH', null).getText().replace('.', '_'))
				.withLabel(fieldNode.getChildElement('LABEL', null).getText())
				.withDescription('Object type: ' + fieldNode.getChildElement('OBJECTNAME', null).getText())
				.withType(fieldNode.getChildElement('RELATIONSHIPTYPE', null).getText())
				.setMap(true, true)
				.setEditable(false) // not directly editable
				.build()
			);
		}

		return fields;
	}

	// ---------------------------------
	// ----- LazyLoadSchemaAdapter -----
	// ---------------------------------

	/**
	 * Tell Valence how to go about retrieving records from this Adapter.
	 *
	 * @param tableName Which table this Link is interacting with
	 * @param path The field path describing the lazy field we're interested in
	 *
	 * @return The strategy to use when fetching records from this Adapter's endpoint
	 */
	public List<valence.Field> getLazyFieldChildren(String tableName, valence.FieldPath path) {

		Dom.XmlNode objectDefinition = null; // our goal is to populate this with the object definition that matches the end of our FieldPath chain of objects

		// start from our top-level object this Link reads from or writes to
		String tableToInspect = tableName;

		// drill down through the sequence, working our way through the schema object graph until we hit the end of our path
		List<valence.Field> sequence = path.getSequence();
		while(!sequence.isEmpty()) {

			// set up our function
			IntacctFunction fieldsFunction = new IntacctFunction('<lookup><object>' + tableName + '</object></lookup>', true);

			// call the API
			sendFunction(fieldsFunction);

			objectDefinition = fieldsFunction.responseData.getChildElement('Type', null);

			String fieldName = sequence.remove(0).name; // get the name of the next field in our chain

			// get all relationship definitions
			for(Dom.XmlNode fieldNode : objectDefinition.getChildElement('Relationships', null).getChildElements()) {

				/*
				 * We search through the relationships on this object because we know the name of the field we're looking for, but we don't know what kind of object
				 * that field points to. In order to query the next object we need to exchange a field name for an object type name.
				 */
				if(fieldName.equalsIgnoreCase(fieldNode.getChildElement('OBJECTPATH', null).getText())) {
					tableToInspect = fieldNode.getChildElement('OBJECTNAME', null).getText();
					break;
				}
			}
		}

		// we finally found the right object and now we have its object definition, so standard field parse from here

		return parseFields(objectDefinition);
	}

	// -------------------------------------
	// ----- ConfigurableSourceAdapter -----
	// -------------------------------------

	public String explainSourceConfiguration(valence.LinkContext context, String configData) {
		SourceConfiguration config = parseSourceConfig(configData);
		return String.format('<p>Using company ID <strong>{0}</strong> and sender ID <strong>{1}</strong></p>', new List<Object>{config.companyId, config.senderId});
	}

	public String getSourceConfigurationLightningComponent(valence.LinkContext context) {
		return null;
	}

	public String getSourceConfigurationStructure(valence.LinkContext context) {
		return null;
	}

	public void setSourceConfiguration(valence.LinkContext context, String configData) {
		SourceConfiguration sourceConfig = parseSourceConfig(configData);
		SENDER_ID = sourceConfig.senderId;
		SENDER_PASSWORD = sourceConfig.senderPassword;
		COMPANY_ID = sourceConfig.companyId;
	}

	// ----------------------------------------
	// ----- SourceAdapterScopeSerializer -----
	// ----------------------------------------

	public valence.FetchStrategy planFetch(valence.LinkContext context) {

		// calculate actual page size to use
		Integer pageSize = context.batchSizeLimit < 2000 ? context.batchSizeLimit : 2000;

		// set up our function
		IntacctFunction queryFunction = buildQueryFunction(context, 1, 0);

		// call the API
		sendFunction(queryFunction);

		// extract record count
		Integer totalRecords = Integer.valueOf(queryFunction.responseData.getAttributeValue('totalcount', null));

		// based on count, decide what to do next
		if(totalRecords == 0) {
			return valence.FetchStrategy.noRecords();
		}
		else if(totalRecords <= pageSize) {
			return valence.FetchStrategy.immediate(totalRecords);
		}
		else {
			List<FetchScope> scopes = new List<FetchScope>();
			Integer offset = 0;
			while(offset < totalRecords) {
				scopes.add(new FetchScope(pageSize, offset));
				offset += pageSize;
			}
			return valence.FetchStrategy.scopes(scopes, totalRecords);
		}
	}

	/**
	 * Called by Valence framework to retrieve a batch of records from the target endpoint.
	 *
	 * @param context Details about this Link run
	 * @param scope Specific details about the current scope
	 *
	 * @return A batch of records
	 */
	public List<valence.RecordInFlight> fetchRecords(valence.LinkContext context, Object scope) {

		Integer pageSize = context.batchSizeLimit < 2000 ? context.batchSizeLimit : 2000;
		Integer offset = 0;

		if(scope != null) {
			FetchScope scopeObj = (FetchScope)scope;
			pageSize = scopeObj.pageSize;
			offset = scopeObj.offset;
		}

		// set up our function
		IntacctFunction queryFunction = buildQueryFunction(context, pageSize, offset);

		// call the API
		sendFunction(queryFunction);

		// parse results
		List<valence.RecordInFlight> records = new List<valence.RecordInFlight>();
		for(Dom.XmlNode recordNode : queryFunction.responseData.getChildElements()) {
			Map<String, String> properties = new Map<String, String>();
			for(Dom.XmlNode fieldNode : recordNode.getChildElements()) {
				properties.put(fieldNode.getName().replace('.', '_'), fieldNode.getText());
			}
			records.add(new valence.RecordInFlight(properties));
		}

		return records;
	}

	public Object deserializeScope(String serializedScope) {
		return JSON.deserialize(serializedScope, FetchScope.class);
	}

	public String serializeScope(Object scope) {
		return JSON.serialize(scope);
	}

	// -------------------------
	// ----- TargetAdapter -----
	// -------------------------

	public Integer getBatchSizeLimit(valence.LinkContext context) {
		return 100;
	}

	public void pushRecords(valence.LinkContext context, List<valence.RecordInFlight> records) {

		// don't send any data if this Link is running in testing mode
		if(context.testingMode == true) {
			return;
		}

		Map<String, valence.RecordInFlight> recordsByControlId = new Map<String, valence.RecordInFlight>();
		List<IntacctFunction> functions = new List<IntacctFunction>();

		// build a function representation for each record to be sent
		for(valence.RecordInFlight record : records) {

			/*
			 * Intacct doesn't support upsert calls, so we need to split out upsert records into create or update operations. We do this by inspecting a
			 * configurable "key field" for a value. If populated, we assume this is an update, if empty we assume a create.
			 */
			if('upsert'.equalsIgnoreCase(record.getOperation())) {
				if(String.isNotBlank(String.valueOf(record.getPropertyValue(targetConfig.keyField)))) {
					// UPDATE
					record.setOperation('update');
					record.setCreated(false);
				}
				else {
					// CREATE
					record.setOperation('create');
					record.setCreated(true);
					record.getProperties().remove(targetConfig.keyField); // remove the key field so Intacct doesn't complain about a null or missing key
				}
			}
			IntacctFunction function = buildRecordFunction(record, context.linkTargetName);
			functions.add(function);
			recordsByControlId.put(function.controlId, record);
		}

		// call the Intacct API
		sendFunctions(functions);

		/*
		 * Now it's time to parse the API responses and apply them to each RecordInFlight
		 */
		List<IntacctFunction> writebacks = new List<IntacctFunction>();
		for(IntacctFunction function : functions) {
			valence.RecordInFlight record = recordsByControlId.get(function.controlId);
			if(record == null) {
				throw new valence.AdapterException('Unable to match function controlid <' + function.controlId + '> to a RecordInFlight.');
			}
			if(function.success == true) {
				record.setSuccess(true);
				if(record.isCreated() == true && String.isNotBlank(targetConfig.writebackField)) {
					writebacks.add(function);
				}
			}
			else {
				record.addError(function.errorMessage);
			}
		}

		/*
		 * If we generated writebacks, update records in Salesforce.
		 */
		List<SObject> writes = new List<SObject>();
		System.Type sObjectType = Type.forName(context.linkSourceName);
		for(IntacctFunction writeback : writebacks) {
			SObject o = (SObject)sObjectType.newInstance();
			o.put('Id', recordsByControlId.get(writeback.controlId).getSalesforceId());
			o.put(targetConfig.writebackField, writeback.extractIdentifier(targetConfig.keyField));
			writes.add(o);
		}
		if(!writes.isEmpty()) {
			List<Database.SaveResult> results = Database.update(writes, false);
			for(Integer i = 0, j = results.size(); i < j; i++) {
				if(results[i].success == false) {
					recordsByControlId.get(writebacks[i].controlId).addError('Writeback error: ' + results[i].errors);
				}
			}
		}
	}

	// -------------------------------------
	// ----- ConfigurableTargetAdapter -----
	// -------------------------------------

	public String explainTargetConfiguration(valence.LinkContext context, String configData) {
		TargetConfiguration config = parseTargetConfig(configData);
		return String.format('<p>Using company ID <strong>{0}</strong> and sender ID <strong>{1}</strong><p>The {2} field will be used as the Intacct unique identifier. {3}</p>', new List<Object>{
			config.companyId,
			config.senderId,
			config.keyField != null ? config.keyField : 'RECORDNO',
			String.isNotBlank(config.writebackField) ? 'Identifiers will be written back to the ' + config.writebackField + ' field on the Salesforce record.' : 'No identifiers will be written back to Salesforce.'
		});
	}

	public String getTargetConfigurationLightningComponent(valence.LinkContext context) {
		return 'c:intacctAdapterTargetConfigurator';
	}

	public String getTargetConfigurationStructure(valence.LinkContext context) {
		return null;
	}

	public void setTargetConfiguration(valence.LinkContext context, String configData) {
		targetConfig = parseTargetConfig(configData);
		SENDER_ID = targetConfig.senderId;
		SENDER_PASSWORD = targetConfig.senderPassword;
		COMPANY_ID = targetConfig.companyId;
	}

	// -------------------
	// ----- Helpers -----
	// -------------------

	/**
	 * Build XML that can call the 'query' function in the Intacct API.
	 *
	 * @param context Info about the running Link
	 * @param pageSize How many records to return in the result
	 * @param offset An offset to pass to Intacct if we are not on the first page of results
	 *
	 * @return A wrapper object we can use to interact with the Intacct API
	 */
	@TestVisible
	private IntacctFunction buildQueryFunction(valence.LinkContext context, Integer pageSize, Integer offset) {
		Set<String> selectFields = new Set<String>();
		for(valence.FieldPath path : context.suggestedQueryFields) {
			selectFields.add(path.getLast().name);
		}
		return new IntacctFunction(String.format(
			//@formatter:off
			'<query>' +
				'<select><field>{0}</field></select>' +
				'<object>{1}</object>' +
				'{2}' +
				'<pagesize>{3}</pagesize>' +
				'<offset>{4}</offset>' +
			'</query>',
			//@formatter:on
			new List<Object>{
				String.join(new List<String>(selectFields), '</field><field>'),
				context.linkSourceName,
				buildDeltaFilter(context.lastSuccessfulSync),
				pageSize,
				offset
			}), true);
	}

	/**
	 * Create the appropriate XML for filtering results based on last modified timestamp.
	 *
	 * @param timestamp The timestamp to filter on
	 *
	 * @return XML that can be used in the Intacct API to filter results
	 */
	@TestVisible
	private String buildDeltaFilter(Datetime timestamp) {
		return timestamp != null ?
			'<filter><greaterthanorequalto><field>WHENMODIFIED</field><value>' + timestamp.format(INTACCT_DATE_FORMAT, SERVER_TIMEZONE) + '</value></greaterthanorequalto></filter>'
			: '';
	}

	/**
	 * Build XML that can call a CRUD function on a single record in the Intacct API.
	 *
	 * @param record A single record to be manipulated
	 * @param intacctTableName The name of the object we're writing to in Intacct
	 *
	 * @return A wrapper object we can use to interact with the Intacct API
	 */
	@TestVisible
	private IntacctFunction buildRecordFunction(valence.RecordInFlight record, String intacctTableName) {
		return new IntacctFunction(String.format('<{1}><{2}>{0}</{2}></{1}>', new List<Object>{recordToXml(record), record.getOperation(), intacctTableName}), false);
	}

	/**
	 * Convenience method for calling sendFunctions() with a single function instance.
	 *
	 * @param function A function that will be immediately sent to the Intacct API
	 */
	@TestVisible
	private void sendFunction(IntacctFunction function) {
		sendFunctions(new List<IntacctFunction>{function});
	}

	/**
	 * Given some functions, make an API call to Intacct and apply the results back to those functions.
	 *
	 * @param functions Functions to send to Intacct and which will be individually updated with the API responses to each function's payload
	 */
	@TestVisible
	private void sendFunctions(List<IntacctFunction> functions) {

		Map<String, IntacctFunction> functionsByControlId = new Map<String, IntacctFunction>();
		String cumulativePayload = '';
		for(IntacctFunction function : functions) {
			functionsByControlId.put(function.controlId, function);
			cumulativePayload += function.getXML();
		}

		HttpRequest req = buildRequest(cumulativePayload);

		// send the request
		HttpResponse res = new Http().send(req);

		// check for top-level errors
		checkForErrors(res);

		// apply each result to its matching function
		for(Dom.XmlNode element : res.getBodyDocument().getRootElement().getChildElement('operation', null).getChildElements()) {
			if('result'.equalsIgnoreCase(element.getName())) { // the <authentication> element is at the same level as result elements
				String controlId = element.getChildElement('controlid', null).getText();
				IntacctFunction matchingFunction = Test.isRunningTest() ? functionsByControlId.values()[0] : functionsByControlId.get(controlId);
				if(matchingFunction == null) {
					throw new valence.AdapterException('Unable to match function controlid <' + controlId + '> to a function.');
				}
				matchingFunction.applyResponse(element);
			}
		}
	}


	/**
	 * Simple helper method for building HTTPRequest instances that are appropriately configured.
	 *
	 * @functionXML The XML operation body that will be injected into the standard request envelope
	 * @sessionId An existing sessionId, if one is available (fine to send null)
	 *
	 * @param functionXML XML for one or more function calls to the server
	 *
	 * @return A request, ready to be sent
	 */
	@TestVisible
	private HttpRequest buildRequest(String functionXML) {

		HttpRequest req = new HttpRequest();
		req.setEndpoint('callout:' + namedCredential);
		req.setMethod('POST');
		req.setHeader('Content-Type', 'application/xml');
		req.setHeader('Accept-Encoding', 'gzip');
		req.setTimeout(120000);
		req.setBody(String.format('<?xml version="1.0" encoding="UTF-8"?>' +
			//@formatter:off
			'<request>' +
			'<control>' +
			'<senderid>{0}</senderid>' +
			'<password>{1}</password>' +
			'<controlid>{2}</controlid>' +
			'<uniqueid>false</uniqueid>' +
			'<dtdversion>3.0</dtdversion>' +
			'<includewhitespace>false</includewhitespace>' +
			'</control>' +
			'<operation>' +
			'<authentication>{3}</authentication>' +
			'<content>{4}</content>' +
			'</operation>' +
			'</request>',
			//@formatter:on
			new List<Object>{
				SENDER_ID,
				SENDER_PASSWORD,
				generateControlId(),
				'<login><userid>{!$Credential.Username}</userid><companyid>' + COMPANY_ID + '</companyid><password>{!$Credential.Password}</password></login>',
				functionXML
			}
		));

		return req;
	}

	/**
	 * Check for errors at the transport layer of an HTTP response as well as the control and authentication layers.
	 *
	 * @param response The API response to inspect for errors
	 * @throws AdapterException if errors are encountered
	 */
	private void checkForErrors(HttpResponse response) {
		if(response.getStatusCode() < 200 || response.getStatusCode() >= 300) {
			String extraDetails = '';
			try {
				extraDetails = extractErrorMessage(response.getBodyDocument().getRootElement());
			}
			catch(Exception e) {
				// oh well
			}
			finally {
				throw new valence.AdapterException(response.getStatusCode() + ':' + response.getStatus() + '(' + extraDetails + ')');
			}
		}

		Dom.XmlNode root = response.getBodyDocument().getRootElement();

		// first check for correct authentication at the top level (sender level)
		Boolean controlSuccess = 'success'.equalsIgnoreCase(
			root.getChildElement('control', null)
				.getChildElement('status', null).getText());

		if(!controlSuccess) {
			throw new valence.AdapterException(extractErrorMessage(root));
		}

		// next, check for correct authentication at the org level
		Dom.XmlNode operation = root.getChildElement('operation', null);
		Boolean orgAuthSuccess = 'success'.equalsIgnoreCase(
			operation.getChildElement('authentication', null)
				.getChildElement('status', null).getText());

		if(!orgAuthSuccess) {
			throw new valence.AdapterException(extractErrorMessage(operation));
		}
	}

	/**
	 * Extract error details from Intacct API error payload.
	 *
	 * @param baseNode The XMLNode that has an <errormessage> child
	 *
	 * @return A human-readable error message
	 */
	private static String extractErrorMessage(Dom.XmlNode baseNode) {
		List<String> errorMessageParts = new List<String>();
		Dom.XmlNode errorNode = baseNode.getChildElement('errormessage', null).getChildElement('error', null);
		Dom.XmlNode errorno = errorNode.getChildElement('errorno', null);
		if(errorno != null && String.isNotBlank(errorno.getText())) {
			errorMessageParts.add(errorno.getText());
		}
		Dom.XmlNode desc1 = errorNode.getChildElement('description', null);
		if(desc1 != null && String.isNotBlank(desc1.getText())) {
			errorMessageParts.add(desc1.getText());
		}
		Dom.XmlNode desc2 = errorNode.getChildElement('description2', null);
		if(desc2 != null && String.isNotBlank(desc2.getText())) {
			errorMessageParts.add(desc2.getText());
		}
		return String.join(errorMessageParts, '::').trim();
	}

	private static String generateControlId() {
		return EncodingUtil.convertToHex(Crypto.generateAesKey(128));
	}

	/**
	 * @param record A single RecordInFlight
	 *
	 * @return An XML representation of a RecordInFlight
	 */
	private String recordToXml(valence.RecordInFlight record) {
		return propsToXml(record.getProperties());
	}

	private String propsToXml(Map<String, Object> props) {
		String retVal = '';
		for(String key : props.keySet()) {
			Object value = props.get(key);
			retVal += String.format('<{0}>{1}</{0}>',
				new List<Object>{
					key,
					value instanceof Map<String, Object> ? propsToXml((Map<String, Object>)value) : value,
					key
				}
			);
		}
		return retVal;
	}

	private static SourceConfiguration parseSourceConfig(String configData) {
		if(String.isNotBlank(configData)) {
			return (SourceConfiguration)JSON.deserialize(configData, SourceConfiguration.class);
		}
		else {
			return new SourceConfiguration();
		}
	}

	private static TargetConfiguration parseTargetConfig(String configData) {
		if(String.isNotBlank(configData)) {
			return (TargetConfiguration)JSON.deserialize(configData, TargetConfiguration.class);
		}
		else {
			return new TargetConfiguration();
		}
	}

	private virtual class Configuration {

		private String senderId;
		private String senderPassword;
		private String companyId;
	}

	private class SourceConfiguration extends Configuration {

	}

	/**
	 * Simple class for holding the configuration needed when writing to the external API.
	 */
	private class TargetConfiguration extends Configuration {

		@TestVisible
		private String keyField = null;
		@TestVisible
		private String writebackField = null;

		private TargetConfiguration() {
		}

		private TargetConfiguration(String defaultKeyField, String defaultWritebackField) {
			this.keyField = defaultKeyField;
			this.writebackField = defaultWritebackField;
		}
	}

	@TestVisible
	private class FetchScope {

		@TestVisible
		private Integer pageSize;
		@TestVisible
		private Integer offset;

		@TestVisible
		private FetchScope(Integer pageSize, Integer offset) {
			this.pageSize = pageSize;
			this.offset = offset;
		}
	}

	/**
	 * Container for making an API call to Intacct. It holds the payload, metadata about the function call, and details about the response.
	 */
	@TestVisible
	private class IntacctFunction {

		@TestVisible
		String controlId;
		Boolean exceptionOnFailure; // set to true if this function getting an unsuccessful response from the API should generate a Valence exception
		String payload;

		Boolean success;
		Dom.XmlNode responseData;
		String errorMessage;

		IntacctFunction(String payload, Boolean exceptionOnFailure) {
			this.controlId = generateControlId();
			this.payload = payload;
			this.exceptionOnFailure = exceptionOnFailure;
		}

		String getXML() {
			return String.format('<function controlid="{0}">{1}</function>', new List<Object>{controlId, payload});
		}

		/**
		 * @param resultNode The response to this function from the Intacct API
		 */
		void applyResponse(Dom.XmlNode resultNode) {

			// check whether we were successful
			success = 'success'.equalsIgnoreCase(resultNode.getChildElement('status', null).getText());

			if(success == false) {
				errorMessage = extractErrorMessage(resultNode);
				if(exceptionOnFailure == true) {
					throw new valence.AdapterException(errorMessage);
				}
			}

			responseData = resultNode.getChildElement('data', null);
		}

		private String extractIdentifier(String keyFieldName) {
			// fetch first child because the API is unreliable on uppercase/lowercase object names
			return responseData.getChildElements()[0].getChildElement(keyFieldName, null).getText();
		}
	}
}