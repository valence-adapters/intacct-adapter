/**
 * Exercises the IntacctAdapter class.
 */
@IsTest
private class IntacctAdapterTests implements HttpCalloutMock {

	private static valence.LinkContext context;

	static {
		context = new valence.LinkContext();
		context.linkSourceName = 'APBILL';
		context.batchSizeLimit = 5;
		context.mappings = new Map<String, valence.Mapping>();
		context.suggestedQueryFields = new List<valence.FieldPath>();
	}

	/**
	 * Mock various API responses to the messages we send from our Adapter.
	 *
	 * @param req The request to interpret
	 *
	 * @return A mock response
	 */
	public HttpResponse respond(HttpRequest req) {

		HttpResponse res = new HttpResponse();
		res.setStatus('OK');
		res.setStatusCode(200);

		if(req.getEndpoint().startsWith('callout:SenderAuthFailure')) {
			res.setBody(
				'<?xml version="1.0" encoding="UTF-8"?>' +
					'<response>' +
					'<control>' +
					'<status>failure</status>' +
					'<senderid>ExampleSender</senderid>' +
					'<controlid>1585778561</controlid>' +
					'<uniqueid>false</uniqueid>' +
					'<dtdversion>3.0</dtdversion>' +
					'</control>' +
					'<errormessage>' +
					'<error>' +
					'<errorno>XL03000006</errorno>' +
					'<description></description>' +
					'<description2>Incorrect Intacct XML Partner ID or password.</description2>' +
					'<correction></correction>' +
					'</error>' +
					'</errormessage>' +
					'</response>');
		}
		else if(req.getEndpoint().startsWith('callout:OrgAuthFailure1')) {
			res.setBody(
				'<?xml version="1.0" encoding="UTF-8"?>' +
					'<response>' +
					'<control>' +
					'<status>success</status>' +
					'<senderid>ExampleSender</senderid>' +
					'<controlid>1585779573</controlid>' +
					'<uniqueid>false</uniqueid>' +
					'<dtdversion>3.0</dtdversion>' +
					'</control>' +
					'<operation>' +
					'<authentication>' +
					'<status>failure</status>' +
					'<userid>ExampleUser</userid>' +
					'<companyid>ExampleCompany</companyid>' +
					'<locationid></locationid>' +
					'</authentication>' +
					'<errormessage>' +
					'<error>' +
					'<errorno>XL03000006</errorno>' +
					'<description></description>' +
					'<description2>Sign-in information is incorrect</description2>' +
					'<correction></correction>' +
					'</error>' +
					'</errormessage>' +
					'</operation>' +
					'</response>');
		}
		else if(req.getEndpoint().startsWith('callout:OrgAuthFailure2')) {
			res.setBody(
				'<?xml version="1.0" encoding="UTF-8"?>' +
					'<response>' +
					'<control>' +
					'<status>failure</status>' +
					'</control>' +
					'<errormessage>' +
					'<error>' +
					'<errorno>XMLGW_JPP0002</errorno>' +
					'<description>Sign-in information is incorrect. Please check your request.</description>' +
					'</error>' +
					'</errormessage>' +
					'</response>');
		}
		else if(req.getEndpoint().startsWith('callout:FunctionFailure')) {
			res.setBody(
				'<?xml version="1.0" encoding="UTF-8"?>' +
					'<response>' +
					'<control>' +
					'<status>success</status>' +
					'<senderid>ExampleSender</senderid>' +
					'<controlid>1585779722</controlid>' +
					'<uniqueid>false</uniqueid>' +
					'<dtdversion>3.0</dtdversion>' +
					'</control>' +
					'<operation>' +
					'<authentication>' +
					'<status>success</status>' +
					'<userid>ExampleUser</userid>' +
					'<companyid>ExampleCompany</companyid>' +
					'<locationid></locationid>' +
					'<sessiontimestamp>2020-04-01T22:22:02+00:00</sessiontimestamp>' +
					'<sessiontimeout>2020-04-02T13:22:02+00:00</sessiontimeout>' +
					'</authentication>' +
					'<result>' +
					'<status>failure</status>' +
					'<function>readByQuery</function>' +
					'<controlid>329f28f9-dd29-4778-8e46-e4013a7b847c</controlid>' +
					'<errormessage>' +
					'<error>' +
					'<errorno>PL04000005</errorno>' +
					'<description></description>' +
					'<description2>You do not have permission for API operation READ_BY_QUERY on objects of type apbill</description2>' +
					'<correction></correction>' +
					'</error>' +
					'</errormessage>' +
					'</result>' +
					'</operation>' +
					'</response>');
		}
		else if(req.getEndpoint().startsWith('callout:getFields')) {
			res.setBody(
				'<?xml version="1.0" encoding="UTF-8"?>\n' +
					'<response>\n' +
					'<control>\n' +
					'<status>success</status>\n' +
					'<senderid>ExampleSender</senderid>\n' +
					'<controlid>1d4de9d0afca2d38433d56c7b12069cb</controlid>\n' +
					'<uniqueid>false</uniqueid>\n' +
					'<dtdversion>3.0</dtdversion>\n' +
					'</control>\n' +
					'<operation>\n' +
					'<authentication>\n' +
					'<status>success</status>\n' +
					'<userid>ExampleUser</userid>\n' +
					'<companyid>ExampleCompany</companyid>\n' +
					'<locationid></locationid>\n' +
					'<sessiontimestamp>2021-10-08T19:08:31+00:00</sessiontimestamp>\n' +
					'<sessiontimeout>2021-10-09T10:08:31+00:00</sessiontimeout>\n' +
					'</authentication>\n' +
					'<result>\n' +
					'<status>success</status>\n' +
					'<function>lookup</function>\n' +
					'<controlid>eaec66cdce46889db81950bd778a2b66</controlid>\n' +
					'<data listtype="All" count="1">\n' +
					'<Type Name="APBILL" DocumentType="">\n' +
					'<Fields>\n' +
					'<Field>\n' +
					'<ID>RECORDNO</ID>\n' +
					'<LABEL>Record number</LABEL>\n' +
					'<DESCRIPTION>No description specified</DESCRIPTION>\n' +
					'<REQUIRED>false</REQUIRED>\n' +
					'<READONLY>true</READONLY>\n' +
					'<DATATYPE>INTEGER</DATATYPE>\n' +
					'<ISCUSTOM>false</ISCUSTOM>\n' +
					'</Field>\n' +
					'<Field>\n' +
					'<ID>RECORDTYPE</ID>\n' +
					'<LABEL>Record type</LABEL>\n' +
					'<DESCRIPTION>No description specified</DESCRIPTION>\n' +
					'<REQUIRED>false</REQUIRED>\n' +
					'<READONLY>false</READONLY>\n' +
					'<DATATYPE>TEXT</DATATYPE>\n' +
					'<ISCUSTOM>false</ISCUSTOM>\n' +
					'</Field>\n' +
					'<Field>\n' +
					'<ID>RECORDID</ID>\n' +
					'<LABEL>Bill number</LABEL>\n' +
					'<DESCRIPTION>No description specified</DESCRIPTION>\n' +
					'<REQUIRED>false</REQUIRED>\n' +
					'<READONLY>false</READONLY>\n' +
					'<DATATYPE>TEXT</DATATYPE>\n' +
					'<ISCUSTOM>false</ISCUSTOM>\n' +
					'</Field>\n' +
					'<Field>\n' +
					'<ID>FINANCIALENTITY</ID>\n' +
					'<LABEL>Financial entity</LABEL>\n' +
					'<DESCRIPTION>No description specified</DESCRIPTION>\n' +
					'<REQUIRED>false</REQUIRED>\n' +
					'<READONLY>false</READONLY>\n' +
					'<DATATYPE>TEXT</DATATYPE>\n' +
					'<ISCUSTOM>false</ISCUSTOM>\n' +
					'</Field>\n' +
					'<Field>\n' +
					'<ID>STATE</ID>\n' +
					'<LABEL>State</LABEL>\n' +
					'<DESCRIPTION>No description specified</DESCRIPTION>\n' +
					'<REQUIRED>false</REQUIRED>\n' +
					'<READONLY>true</READONLY>\n' +
					'<DATATYPE>TEXT</DATATYPE>\n' +
					'<ISCUSTOM>false</ISCUSTOM>\n' +
					'</Field>\n' +
					'<Field>\n' +
					'<ID>RAWSTATE</ID>\n' +
					'<LABEL>Raw state</LABEL>\n' +
					'<DESCRIPTION>No description specified</DESCRIPTION>\n' +
					'<REQUIRED>false</REQUIRED>\n' +
					'<READONLY>true</READONLY>\n' +
					'<DATATYPE>TEXT</DATATYPE>\n' +
					'<ISCUSTOM>false</ISCUSTOM>\n' +
					'</Field>\n' +
					'<Field>\n' +
					'<ID>VENDORID</ID>\n' +
					'<LABEL>Vendor ID</LABEL>\n' +
					'<DESCRIPTION>No description specified</DESCRIPTION>\n' +
					'<REQUIRED>true</REQUIRED>\n' +
					'<READONLY>false</READONLY>\n' +
					'<DATATYPE>TEXT</DATATYPE>\n' +
					'<ISCUSTOM>false</ISCUSTOM>\n' +
					'</Field>\n' +
					'<Field>\n' +
					'<ID>VENDORNAME</ID>\n' +
					'<LABEL>Vendor name</LABEL>\n' +
					'<DESCRIPTION>No description specified</DESCRIPTION>\n' +
					'<REQUIRED>false</REQUIRED>\n' +
					'<READONLY>false</READONLY>\n' +
					'<DATATYPE>TEXT</DATATYPE>\n' +
					'<ISCUSTOM>false</ISCUSTOM>\n' +
					'</Field>\n' +
					'<Field>\n' +
					'<ID>FORM1099TYPE</ID>\n' +
					'<LABEL>Form 1099 type</LABEL>\n' +
					'<DESCRIPTION>No description specified</DESCRIPTION>\n' +
					'<REQUIRED>false</REQUIRED>\n' +
					'<READONLY>false</READONLY>\n' +
					'<DATATYPE>TEXT</DATATYPE>\n' +
					'<ISCUSTOM>false</ISCUSTOM>\n' +
					'</Field>\n' +
					'<Field>\n' +
					'<ID>FORM1099BOX</ID>\n' +
					'<LABEL>Form 1099 box</LABEL>\n' +
					'<DESCRIPTION>No description specified</DESCRIPTION>\n' +
					'<REQUIRED>false</REQUIRED>\n' +
					'<READONLY>false</READONLY>\n' +
					'<DATATYPE>TEXT</DATATYPE>\n' +
					'<ISCUSTOM>false</ISCUSTOM>\n' +
					'</Field>\n' +
					'</Fields>\n' +
					'<Relationships>\n' +
					'<Relationship>\n' +
					'<OBJECTPATH>VENDOR</OBJECTPATH>\n' +
					'<OBJECTNAME>VENDOR</OBJECTNAME>\n' +
					'<LABEL></LABEL>\n' +
					'<RELATIONSHIPTYPE>MANY2ONE</RELATIONSHIPTYPE>\n' +
					'<RELATEDBY>VENDORID</RELATEDBY>\n' +
					'</Relationship>\n' +
					'<Relationship>\n' +
					'<OBJECTPATH>PODOCUMENT</OBJECTPATH>\n' +
					'<OBJECTNAME>PODOCUMENT</OBJECTNAME>\n' +
					'<LABEL></LABEL>\n' +
					'<RELATIONSHIPTYPE>ONE2ONE</RELATIONSHIPTYPE>\n' +
					'<RELATEDBY>RECORD#</RELATEDBY>\n' +
					'</Relationship>\n' +
					'<Relationship>\n' +
					'<OBJECTPATH>PAYTO</OBJECTPATH>\n' +
					'<OBJECTNAME>CONTACTVERSION</OBJECTNAME>\n' +
					'<LABEL>Pay to Contact</LABEL>\n' +
					'<RELATIONSHIPTYPE>MANY2ONE</RELATIONSHIPTYPE>\n' +
					'<RELATEDBY>BILLTOPAYTOKEY</RELATEDBY>\n' +
					'</Relationship>\n' +
					'<Relationship>\n' +
					'<OBJECTPATH>RETURNTO</OBJECTPATH>\n' +
					'<OBJECTNAME>CONTACTVERSION</OBJECTNAME>\n' +
					'<LABEL>Return to Contact</LABEL>\n' +
					'<RELATIONSHIPTYPE>MANY2ONE</RELATIONSHIPTYPE>\n' +
					'<RELATEDBY>SHIPTORETURNTOKEY</RELATEDBY>\n' +
					'</Relationship>\n' +
					'<Relationship>\n' +
					'<OBJECTPATH>TERM</OBJECTPATH>\n' +
					'<OBJECTNAME>APTERM</OBJECTNAME>\n' +
					'<LABEL>Term</LABEL>\n' +
					'<RELATIONSHIPTYPE>MANY2ONE</RELATIONSHIPTYPE>\n' +
					'<RELATEDBY>TERMNAME</RELATEDBY>\n' +
					'</Relationship>\n' +
					'<Relationship>\n' +
					'<OBJECTPATH>EXCHANGERATEINFO</OBJECTPATH>\n' +
					'<OBJECTNAME>EXCHANGERATEINFO</OBJECTNAME>\n' +
					'<LABEL></LABEL>\n' +
					'<RELATIONSHIPTYPE>MANY2ONE</RELATIONSHIPTYPE>\n' +
					'<RELATEDBY>RECORDNO</RELATEDBY>\n' +
					'</Relationship>\n' +
					'<Relationship>\n' +
					'<OBJECTPATH>APRECURBILL</OBJECTPATH>\n' +
					'<OBJECTNAME>APRECURBILL</OBJECTNAME>\n' +
					'<LABEL></LABEL>\n' +
					'<RELATIONSHIPTYPE>MANY2ONE</RELATIONSHIPTYPE>\n' +
					'<RELATEDBY>SCHOPKEY</RELATEDBY>\n' +
					'</Relationship>\n' +
					'<Relationship>\n' +
					'<OBJECTPATH>TAXSOLUTION</OBJECTPATH>\n' +
					'<OBJECTNAME>TAXSOLUTION</OBJECTNAME>\n' +
					'<LABEL></LABEL>\n' +
					'<RELATIONSHIPTYPE>MANY2ONE</RELATIONSHIPTYPE>\n' +
					'<RELATEDBY>TAXSOLUTIONKEY</RELATEDBY>\n' +
					'</Relationship>\n' +
					'<Relationship>\n' +
					'<OBJECTPATH>MELOCATION</OBJECTPATH>\n' +
					'<OBJECTNAME>LOCATION</OBJECTNAME>\n' +
					'<LABEL>Created At Entity Information</LABEL>\n' +
					'<RELATIONSHIPTYPE>MANY2ONE</RELATIONSHIPTYPE>\n' +
					'<RELATEDBY>MEGAENTITYID</RELATEDBY>\n' +
					'</Relationship>\n' +
					'</Relationships>\n' +
					'</Type>\n' +
					'</data>\n' +
					'</result>\n' +
					'</operation>\n' +
					'</response>');
		}
		else if(req.getEndpoint().startsWith('callout:getTables')) {
			res.setBody(
				'<?xml version="1.0" encoding="UTF-8"?>' +
					'<response>' +
					'<control>' +
					'<status>success</status>' +
					'<senderid>ExampleSender</senderid>' +
					'<controlid>1585789791</controlid>' +
					'<uniqueid>false</uniqueid>' +
					'<dtdversion>3.0</dtdversion>' +
					'</control>' +
					'<operation>' +
					'<authentication>' +
					'<status>success</status>' +
					'<userid>ExampleUser</userid>' +
					'<companyid>ExampleCompany</companyid>' +
					'<locationid></locationid>' +
					'<sessiontimestamp>2020-04-02T01:09:51+00:00</sessiontimestamp>' +
					'<sessiontimeout>2020-04-02T16:09:51+00:00</sessiontimeout>' +
					'</authentication>' +
					'<result>' +
					'<status>success</status>' +
					'<function>inspect</function>' +
					'<controlid>97eae368-8db5-4ec5-b682-604b8327c292</controlid>' +
					'<data listtype="All" count="1">' +
					'<type typename="CUSTOMER">Customer</type>' +
					'<type typename="CONTACT">Contact</type>' +
					'</data>' +
					'</result>' +
					'</operation>' +
					'</response>');
		}
		else if(req.getEndpoint().startsWith('callout:planFetchNoRecords')) {
			res.setBody(
				'<?xml version="1.0" encoding="UTF-8"?>' +
					'<response>' +
					'<control>' +
					'<status>success</status>' +
					'<senderid>ExampleSender</senderid>' +
					'<controlid>1585784825</controlid>' +
					'<uniqueid>false</uniqueid>' +
					'<dtdversion>3.0</dtdversion>' +
					'</control>' +
					'<operation>' +
					'<authentication>' +
					'<status>success</status>' +
					'<userid>ExampleUser</userid>' +
					'<companyid>ExampleCompany</companyid>' +
					'<locationid></locationid>' +
					'<sessiontimestamp>2020-04-01T23:47:04+00:00</sessiontimestamp>' +
					'<sessiontimeout>2020-04-02T14:47:04+00:00</sessiontimeout>' +
					'</authentication>' +
					'<result>' +
					'<status>success</status>' +
					'<function>query</function>' +
					'<controlid>2c1bf9b1-536e-403a-9b55-4d58c0ab3d6a</controlid>' +
					'<data listtype="contact" count="0" totalcount="0" numremaining="0" resultId="">' +
					'</data>' +
					'</result>' +
					'</operation>' +
					'</response>');
		}
		else if(req.getEndpoint().startsWith('callout:planFetchSomeRecords')) {
			res.setBody(
				'<?xml version="1.0" encoding="UTF-8"?>' +
					'<response>' +
					'<control>' +
					'<status>success</status>' +
					'<senderid>ExampleSender</senderid>' +
					'<controlid>1585784825</controlid>' +
					'<uniqueid>false</uniqueid>' +
					'<dtdversion>3.0</dtdversion>' +
					'</control>' +
					'<operation>' +
					'<authentication>' +
					'<status>success</status>' +
					'<userid>ExampleUser</userid>' +
					'<companyid>ExampleCompany</companyid>' +
					'<locationid></locationid>' +
					'<sessiontimestamp>2020-04-01T23:47:04+00:00</sessiontimestamp>' +
					'<sessiontimeout>2020-04-02T14:47:04+00:00</sessiontimeout>' +
					'</authentication>' +
					'<result>' +
					'<status>success</status>' +
					'<function>query</function>' +
					'<controlid>2c1bf9b1-536e-403a-9b55-4d58c0ab3d6a</controlid>' +
					'<data listtype="contact" count="1" totalcount="5" numremaining="4" resultId="">' +
					'</data>' +
					'</result>' +
					'</operation>' +
					'</response>');
		}
		else if(req.getEndpoint().startsWith('callout:planFetchManyRecords')) {
			res.setBody(
				'<?xml version="1.0" encoding="UTF-8"?>' +
					'<response>' +
					'<control>' +
					'<status>success</status>' +
					'<senderid>ExampleSender</senderid>' +
					'<controlid>1585784825</controlid>' +
					'<uniqueid>false</uniqueid>' +
					'<dtdversion>3.0</dtdversion>' +
					'</control>' +
					'<operation>' +
					'<authentication>' +
					'<status>success</status>' +
					'<userid>ExampleUser</userid>' +
					'<companyid>ExampleCompany</companyid>' +
					'<locationid></locationid>' +
					'<sessiontimestamp>2020-04-01T23:47:04+00:00</sessiontimestamp>' +
					'<sessiontimeout>2020-04-02T14:47:04+00:00</sessiontimeout>' +
					'</authentication>' +
					'<result>' +
					'<status>success</status>' +
					'<function>query</function>' +
					'<controlid>2c1bf9b1-536e-403a-9b55-4d58c0ab3d6a</controlid>' +
					'<data listtype="contact" count="1" totalcount="100" numremaining="99" resultId="">' +
					'</data>' +
					'</result>' +
					'</operation>' +
					'</response>');
		}
		else if(req.getEndpoint().startsWith('callout:fetchRecords')) {
			res.setBody(
				'<?xml version="1.0" encoding="UTF-8"?>' +
					'<response>' +
					'<control>' +
					'<status>success</status>' +
					'<senderid>ExampleSender</senderid>' +
					'<controlid>1585784825</controlid>' +
					'<uniqueid>false</uniqueid>' +
					'<dtdversion>3.0</dtdversion>' +
					'</control>' +
					'<operation>' +
					'<authentication>' +
					'<status>success</status>' +
					'<userid>ExampleUser</userid>' +
					'<companyid>ExampleCompany</companyid>' +
					'<locationid></locationid>' +
					'<sessiontimestamp>2020-04-01T23:47:04+00:00</sessiontimestamp>' +
					'<sessiontimeout>2020-04-02T14:47:04+00:00</sessiontimeout>' +
					'</authentication>' +
					'<result>' +
					'<status>success</status>' +
					'<function>query</function>' +
					'<controlid>2c1bf9b1-536e-403a-9b55-4d58c0ab3d6a</controlid>' +
					'<data listtype="contact" count="2" totalcount="2" numremaining="0" resultId="">' +
					'<CONTACT>' +
					'<RECORDNO>11</RECORDNO>' +
					'<CONTACTNAME>Acme, Inc</CONTACTNAME>' +
					'<COMPANYNAME>Acme, Inc</COMPANYNAME>' +
					'<PREFIX></PREFIX>' +
					'<FIRSTNAME></FIRSTNAME>' +
					'<LASTNAME></LASTNAME>' +
					'<INITIAL></INITIAL>' +
					'<PRINTAS>Acme, Inc</PRINTAS>' +
					'<TAXABLE>true</TAXABLE>' +
					'<TAXGROUP></TAXGROUP>' +
					'<PHONE1></PHONE1>' +
					'<PHONE2></PHONE2>' +
					'<CELLPHONE></CELLPHONE>' +
					'<PAGER></PAGER>' +
					'<FAX></FAX>' +
					'<EMAIL1></EMAIL1>' +
					'<EMAIL2></EMAIL2>' +
					'<URL1></URL1>' +
					'<URL2></URL2>' +
					'<VISIBLE>true</VISIBLE>' +
					'<MAILADDRESS.ADDRESS1></MAILADDRESS.ADDRESS1>' +
					'<MAILADDRESS.ADDRESS2></MAILADDRESS.ADDRESS2>' +
					'<MAILADDRESS.CITY></MAILADDRESS.CITY>' +
					'<MAILADDRESS.STATE></MAILADDRESS.STATE>' +
					'<MAILADDRESS.ZIP></MAILADDRESS.ZIP>' +
					'<MAILADDRESS.COUNTRY></MAILADDRESS.COUNTRY>' +
					'<STATUS>active</STATUS>' +
					'<MAILADDRESS.COUNTRYCODE></MAILADDRESS.COUNTRYCODE>' +
					'<MAILADDRESS.LATITUDE></MAILADDRESS.LATITUDE>' +
					'<MAILADDRESS.LONGITUDE></MAILADDRESS.LONGITUDE>' +
					'<PRICESCHEDULE></PRICESCHEDULE>' +
					'<DISCOUNT></DISCOUNT>' +
					'<PRICELIST></PRICELIST>' +
					'<PRICELISTKEY></PRICELISTKEY>' +
					'<TAXID></TAXID>' +
					'<TAXGROUPKEY></TAXGROUPKEY>' +
					'<PRICESCHEDULEKEY></PRICESCHEDULEKEY>' +
					'<WHENCREATED>11/27/2019 20:37:09</WHENCREATED>' +
					'<WHENMODIFIED>11/27/2019 20:37:09</WHENMODIFIED>' +
					'<CREATEDBY>9</CREATEDBY>' +
					'<MODIFIEDBY>9</MODIFIEDBY>' +
					'<MEGAENTITYKEY></MEGAENTITYKEY>' +
					'<MEGAENTITYID></MEGAENTITYID>' +
					'<MEGAENTITYNAME></MEGAENTITYNAME>' +
					'</CONTACT>' +
					'<CONTACT>' +
					'<RECORDNO>14</RECORDNO>' +
					'<CONTACTNAME>Fake Group</CONTACTNAME>' +
					'<COMPANYNAME>Fake Group</COMPANYNAME>' +
					'<PREFIX></PREFIX>' +
					'<FIRSTNAME></FIRSTNAME>' +
					'<LASTNAME></LASTNAME>' +
					'<INITIAL></INITIAL>' +
					'<PRINTAS>Fake Group</PRINTAS>' +
					'<TAXABLE>true</TAXABLE>' +
					'<TAXGROUP></TAXGROUP>' +
					'<PHONE1></PHONE1>' +
					'<PHONE2></PHONE2>' +
					'<CELLPHONE></CELLPHONE>' +
					'<PAGER></PAGER>' +
					'<FAX></FAX>' +
					'<EMAIL1></EMAIL1>' +
					'<EMAIL2></EMAIL2>' +
					'<URL1></URL1>' +
					'<URL2></URL2>' +
					'<VISIBLE>true</VISIBLE>' +
					'<MAILADDRESS.ADDRESS1></MAILADDRESS.ADDRESS1>' +
					'<MAILADDRESS.ADDRESS2></MAILADDRESS.ADDRESS2>' +
					'<MAILADDRESS.CITY></MAILADDRESS.CITY>' +
					'<MAILADDRESS.STATE></MAILADDRESS.STATE>' +
					'<MAILADDRESS.ZIP></MAILADDRESS.ZIP>' +
					'<MAILADDRESS.COUNTRY></MAILADDRESS.COUNTRY>' +
					'<STATUS>active</STATUS>' +
					'<MAILADDRESS.COUNTRYCODE></MAILADDRESS.COUNTRYCODE>' +
					'<MAILADDRESS.LATITUDE></MAILADDRESS.LATITUDE>' +
					'<MAILADDRESS.LONGITUDE></MAILADDRESS.LONGITUDE>' +
					'<PRICESCHEDULE></PRICESCHEDULE>' +
					'<DISCOUNT></DISCOUNT>' +
					'<PRICELIST></PRICELIST>' +
					'<PRICELISTKEY></PRICELISTKEY>' +
					'<TAXID></TAXID>' +
					'<TAXGROUPKEY></TAXGROUPKEY>' +
					'<PRICESCHEDULEKEY></PRICESCHEDULEKEY>' +
					'<WHENCREATED>11/27/2019 20:37:09</WHENCREATED>' +
					'<WHENMODIFIED>11/27/2019 20:37:09</WHENMODIFIED>' +
					'<CREATEDBY>9</CREATEDBY>' +
					'<MODIFIEDBY>9</MODIFIEDBY>' +
					'<MEGAENTITYKEY></MEGAENTITYKEY>' +
					'<MEGAENTITYID></MEGAENTITYID>' +
					'<MEGAENTITYNAME></MEGAENTITYNAME>' +
					'</CONTACT>' +
					'</data>' +
					'</result>' +
					'</operation>' +
					'</response>');
		}
		else if(req.getEndpoint().startsWith('callout:pushRecordsFailure')) {
			res.setBody(
				'<?xml version="1.0" encoding="UTF-8"?>\n' +
					'<response>\n' +
					'<control>\n' +
					'<status>success</status>\n' +
					'<senderid>ExampleSender</senderid>\n' +
					'<controlid>6dc3fcd1848d1a7d117f51bf866ed900</controlid>\n' +
					'<uniqueid>false</uniqueid>\n' +
					'<dtdversion>3.0</dtdversion>\n' +
					'</control>\n' +
					'<operation>\n' +
					'<authentication>\n' +
					'<status>success</status>\n' +
					'<userid>ExampleUser</userid>\n' +
					'<companyid>ExampleCompany</companyid>\n' +
					'<locationid></locationid>\n' +
					'<sessiontimestamp>2021-10-08T21:41:15+00:00</sessiontimestamp>\n' +
					'<sessiontimeout>2021-10-09T12:41:15+00:00</sessiontimeout>\n' +
					'</authentication>\n' +
					'<result>\n' +
					'<status>failure</status>\n' +
					'<function>create</function>\n' +
					'<controlid>f01c62e49b90bdf2a964b7ff1e7adf0d</controlid>\n' +
					'<data listtype="objects" count="0"/>\n' +
					'<errormessage>\n' +
					'<error>\n' +
					'<errorno>BL03002128</errorno>\n' +
					'<description></description>\n' +
					'<description2>Enter a Bill number, and try again. [Support ID: WoEB033%7EYWC6%40P0A2Bn-jbwWOJF-0gAAABU]</description2>\n' +
					'<correction></correction>\n' +
					'</error>\n' +
					'<error>\n' +
					'<errorno>BL01001973</errorno>\n' +
					'<description></description>\n' +
					'<description2>Currently, we can&#039;t create the transaction</description2>\n' +
					'<correction>Check the transaction for errors or inconsistencies, then try again.</correction>\n' +
					'</error>\n' +
					'</errormessage>\n' +
					'</result>\n' +
					'</operation>\n' +
					'</response>');
		}
		else if(req.getEndpoint().startsWith('callout:pushRecordsSuccess')) {
			res.setBody(
				'<?xml version="1.0" encoding="UTF-8"?>\n' +
					'<response>\n' +
					'<control>\n' +
					'<status>success</status>\n' +
					'<senderid>ExampleSender</senderid>\n' +
					'<controlid>95e26b1d1b4c7621e45d23c57b1730e8</controlid>\n' +
					'<uniqueid>false</uniqueid>\n' +
					'<dtdversion>3.0</dtdversion>\n' +
					'</control>\n' +
					'<operation>\n' +
					'<authentication>\n' +
					'<status>success</status>\n' +
					'<userid>ExampleUser</userid>\n' +
					'<companyid>ExampleCompany</companyid>\n' +
					'<locationid></locationid>\n' +
					'<sessiontimestamp>2021-10-08T21:34:44+00:00</sessiontimestamp>\n' +
					'<sessiontimeout>2021-10-09T12:34:44+00:00</sessiontimeout>\n' +
					'</authentication>\n' +
					'<result>\n' +
					'<status>success</status>\n' +
					'<function>update</function>\n' +
					'<controlid>477539f8f9c5136dc7f2ba406ef4ce28</controlid>\n' +
					'<data listtype="objects" count="1">\n' +
					'<apbill>\n' +
					'<RECORDNO>62</RECORDNO>\n' +
					'</apbill>\n' +
					'</data>\n' +
					'</result>\n' +
					'</operation>\n' +
					'</response>');
		}

		return res;
	}

	/**
	 * Trap a web services sender authentication failure.
	 */
	@IsTest static void testSenderAuthFailure() {

		Test.setMock(HttpCalloutMock.class, new IntacctAdapterTests());

		IntacctAdapter adapter = new IntacctAdapter();
		adapter.setNamedCredential('SenderAuthFailure');

		try {
			adapter.sendFunction(adapter.buildQueryFunction(context, 10, 1));
			System.assert(false, 'Expected to receive an exception');
		}
		catch(valence.AdapterException e) {
			System.assertEquals('XL03000006::Incorrect Intacct XML Partner ID or password.', e.getMessage());
		}
	}

	/**
	 * Trap a web services org authentication failure.
	 */
	@IsTest static void testOrgAuthFailure1() {

		Test.setMock(HttpCalloutMock.class, new IntacctAdapterTests());

		IntacctAdapter adapter = new IntacctAdapter();
		adapter.setNamedCredential('OrgAuthFailure1');

		try {
			adapter.sendFunction(adapter.buildQueryFunction(context, 10, 1));
			System.assert(false, 'Expected to receive an exception');
		}
		catch(valence.AdapterException e) {
			System.assertEquals('XL03000006::Sign-in information is incorrect', e.getMessage());
		}
	}

	/**
	 * Trap a web services org authentication failure.
	 */
	@IsTest static void testOrgAuthFailure2() {

		Test.setMock(HttpCalloutMock.class, new IntacctAdapterTests());

		IntacctAdapter adapter = new IntacctAdapter();
		adapter.setNamedCredential('OrgAuthFailure2');

		try {
			adapter.sendFunction(adapter.buildQueryFunction(context, 10, 1));
			System.assert(false, 'Expected to receive an exception');
		}
		catch(valence.AdapterException e) {
			System.assertEquals('XMLGW_JPP0002::Sign-in information is incorrect. Please check your request.', e.getMessage());
		}
	}

	/**
	 * Trap a web services function failure.
	 */
	@IsTest static void testFunctionFailure() {

		Test.setMock(HttpCalloutMock.class, new IntacctAdapterTests());

		IntacctAdapter adapter = new IntacctAdapter();
		adapter.setNamedCredential('FunctionFailure');

		try {
			adapter.sendFunction(adapter.buildQueryFunction(context, 10, 1));
			System.assert(false, 'Expected to receive an exception');
		}
		catch(valence.AdapterException e) {
			System.assertEquals('PL04000005::You do not have permission for API operation READ_BY_QUERY on objects of type apbill', e.getMessage());
		}
	}

	/**
	 * Test calling for the table list.
	 */
	@IsTest static void testGetTables() {

		Test.setMock(HttpCalloutMock.class, new IntacctAdapterTests());

		IntacctAdapter adapter = new IntacctAdapter();
		adapter.setNamedCredential('getTables');

		List<valence.Table> tables = adapter.getTables();

		System.assertEquals(2, tables.size());
	}

	/**
	 * Test calling for the field list.
	 */
	@IsTest static void testGetFields() {

		Test.setMock(HttpCalloutMock.class, new IntacctAdapterTests());

		IntacctAdapter adapter = new IntacctAdapter();
		adapter.setNamedCredential('getFields');

		List<valence.Field> fields = adapter.getFields('CONTACT');

		System.assertEquals(19, fields.size());

		System.assertEquals('RECORDNO', fields[0].name);
		System.assertEquals('Record number', fields[0].label);
		System.assertEquals('No description specified', fields[0].description);
		System.assertEquals('INTEGER', fields[0].type);
		System.assertEquals(false, fields[0].isRequired);
		System.assertEquals(false, fields[0].isEditable);

		System.assertEquals('VENDORID', fields[6].name);
		System.assertEquals('Vendor ID', fields[6].label);
		System.assertEquals('No description specified', fields[6].description);
		System.assertEquals('TEXT', fields[6].type);
		System.assertEquals(true, fields[6].isRequired);
		System.assertEquals(true, fields[6].isEditable);
	}

	/**
	 * Test calling for a nested field list. We cheat a little here because the Adapter recursively iterates through the path, calling the API each time for a
	 * new object, but we're going to return the same object every time.
	 */
	@IsTest static void testGetLazyFields() {

		Test.setMock(HttpCalloutMock.class, new IntacctAdapterTests());

		IntacctAdapter adapter = new IntacctAdapter();
		adapter.setNamedCredential('getFields');

		List<valence.Field> fields = adapter.getLazyFieldChildren('CONTACT', valence.FieldPath.buildPath(new List<String>{'RelatedContact', 'AnotherRelatedThing'}));

		System.assertEquals(19, fields.size());

		System.assertEquals('RECORDNO', fields[0].name);
		System.assertEquals('Record number', fields[0].label);
		System.assertEquals('No description specified', fields[0].description);
		System.assertEquals('INTEGER', fields[0].type);
		System.assertEquals(false, fields[0].isRequired);
		System.assertEquals(false, fields[0].isEditable);

		System.assertEquals('VENDORID', fields[6].name);
		System.assertEquals('Vendor ID', fields[6].label);
		System.assertEquals('No description specified', fields[6].description);
		System.assertEquals('TEXT', fields[6].type);
		System.assertEquals(true, fields[6].isRequired);
		System.assertEquals(true, fields[6].isEditable);
	}

	/**
	 * Test an initial call to set up record fetching.
	 */
	@IsTest static void testPlanFetchNone() {

		Test.setMock(HttpCalloutMock.class, new IntacctAdapterTests());

		IntacctAdapter adapter = new IntacctAdapter();
		adapter.setNamedCredential('planFetchNoRecords');

		valence.FetchStrategy strategy = adapter.planFetch(context);

		System.assertEquals(null, strategy.checkExpectedTotalRecords());
		System.assertEquals(null, strategy.checkScopeCount());
		System.assertEquals('NO_RECORDS', strategy.checkStrategyType());
	}

	/**
	 * Test an initial call to set up record fetching.
	 */
	@IsTest static void testPlanFetchImmediate() {

		Test.setMock(HttpCalloutMock.class, new IntacctAdapterTests());

		IntacctAdapter adapter = new IntacctAdapter();
		adapter.setNamedCredential('planFetchSomeRecords');

		valence.FetchStrategy strategy = adapter.planFetch(context);

		System.assertEquals(5, strategy.checkExpectedTotalRecords());
		System.assertEquals(null, strategy.checkScopeCount());
		System.assertEquals('IMMEDIATE', strategy.checkStrategyType());
	}

	/**
	 * Test an initial call to set up record fetching.
	 */
	@IsTest static void testPlanFetchScopes() {

		Test.setMock(HttpCalloutMock.class, new IntacctAdapterTests());

		IntacctAdapter adapter = new IntacctAdapter();
		adapter.setNamedCredential('planFetchManyRecords');

		valence.FetchStrategy strategy = adapter.planFetch(context);

		System.assertEquals(100, strategy.checkExpectedTotalRecords());
		System.assertEquals(20, strategy.checkScopeCount());
		System.assertEquals('SCOPES', strategy.checkStrategyType());
	}

	/**
	 * Test fetching a batch of records.
	 */
	@IsTest static void testFetchRecords() {

		Test.setMock(HttpCalloutMock.class, new IntacctAdapterTests());

		IntacctAdapter adapter = new IntacctAdapter();
		adapter.setNamedCredential('fetchRecords');

		IntacctAdapter.FetchScope scope = new IntacctAdapter.FetchScope(4, 2);
		List<valence.RecordInFlight> records = adapter.fetchRecords(context, scope);

		System.assertEquals(2, records.size());

		System.assertEquals(44, records[0].getOriginalProperties().size());

		System.assertEquals('11', records[0].getOriginalProperties().get('RECORDNO'));
	}

	/**
	 * Test pushing a record unsuccessfully.
	 */
	@IsTest static void testPushRecordsFailure() {

		Test.setMock(HttpCalloutMock.class, new IntacctAdapterTests());

		IntacctAdapter adapter = new IntacctAdapter();
		adapter.setNamedCredential('pushRecordsFailure');

		List<valence.RecordInFlight> records = new List<valence.RecordInFlight>{
			new valence.RecordInFlight(new Map<String, Object>{})
		};
		adapter.pushRecords(context, records);

		System.assertEquals(true, records[0].hasErrors());
		System.assertEquals(false, records[0].isSuccess());
	}

	/**
	 * Test pushing a record successfully.
	 */
	@IsTest static void testPushRecordsSuccessCreate() {

		Test.setMock(HttpCalloutMock.class, new IntacctAdapterTests());

		IntacctAdapter adapter = new IntacctAdapter();
		adapter.setNamedCredential('pushRecordsSuccess');

		List<valence.RecordInFlight> records = new List<valence.RecordInFlight>{
			new valence.RecordInFlight(new Map<String, Object>{})
		};
		adapter.pushRecords(context, records);

		System.assertEquals(false, records[0].hasErrors());
		System.assertEquals(true, records[0].isSuccess());
		System.assertEquals('create', records[0].getOperation());
		System.assertEquals(true, records[0].isCreated());
	}

	/**
	 * Test pushing a record successfully.
	 */
	@IsTest static void testPushRecordsSuccessUpdate() {

		Test.setMock(HttpCalloutMock.class, new IntacctAdapterTests());

		IntacctAdapter adapter = new IntacctAdapter();
		adapter.setNamedCredential('pushRecordsSuccess');

		List<valence.RecordInFlight> records = new List<valence.RecordInFlight>{
			new valence.RecordInFlight(new Map<String, Object>{})
		};
		records[0].getProperties().put('RECORDNO','44');
		adapter.pushRecords(context, records);

		System.assertEquals(false, records[0].hasErrors());
		System.assertEquals(true, records[0].isSuccess());
		System.assertEquals('update', records[0].getOperation());
		System.assertEquals(false, records[0].isCreated());
	}

	/**
	 * Check declared source config Lightning configurator.
	 */
	@IsTest static void getSourceConfigurationLightningComponent() {
		System.assertEquals(null, new IntacctAdapter().getSourceConfigurationLightningComponent(context));
	}

	/**
	 * Check declared source config structure.
	 */
	@IsTest static void getSourceConfigurationStructure() {
		System.assertEquals(null, new IntacctAdapter().getSourceConfigurationStructure(context));
	}

	/**
	 * Check explanation of an appropriate source config.
	 */
	@IsTest static void explainSourceConfiguration() {
		System.assertEquals('<p>Using company ID <strong>12</strong> and sender ID <strong>47</strong></p>', new IntacctAdapter().explainSourceConfiguration(context, '{"companyId":"12","senderId":"47"}'));
	}

	/**
	 * Set a valid and appropriate source configuration.
	 */
	@IsTest static void setSourceConfiguration() {
		IntacctAdapter adapter = new IntacctAdapter();
		adapter.setSourceConfiguration(context, '{"companyId":"12","senderId":"47","senderPassword":"ozzy"}');
		System.assertEquals('47', adapter.SENDER_ID);
		System.assertEquals('ozzy', adapter.SENDER_PASSWORD);
		System.assertEquals('12', adapter.COMPANY_ID);
	}

	/**
	 * Check declared target config Lightning configurator.
	 */
	@IsTest static void getTargetConfigurationLightningComponent() {
		System.assertEquals('c:intacctAdapterTargetConfigurator', new IntacctAdapter().getTargetConfigurationLightningComponent(context));
	}

	/**
	 * Check declared target config structure.
	 */
	@IsTest static void getTargetConfigurationStructure() {
		System.assertEquals(null, new IntacctAdapter().getTargetConfigurationStructure(context));
	}

	/**
	 * Check explanation of an appropriate target config.
	 */
	@IsTest static void explainTargetConfiguration() {
		System.assertEquals('<p>Using company ID <strong>12</strong> and sender ID <strong>47</strong><p>The VENDORID field will be used as the Intacct unique identifier. No identifiers will be written back to Salesforce.</p>', new IntacctAdapter().explainTargetConfiguration(context, '{"companyId":"12","senderId":"47","senderPassword":"ozzy","keyField":"VENDORID"}'));
	}

	/**
	 * Check explanation of an appropriate target config.
	 */
	@IsTest static void explainTargetConfigurationDefaultKeyField() {
		System.assertEquals('<p>Using company ID <strong>12</strong> and sender ID <strong>47</strong><p>The RECORDNO field will be used as the Intacct unique identifier. No identifiers will be written back to Salesforce.</p>', new IntacctAdapter().explainTargetConfiguration(context, '{"companyId":"12","senderId":"47","senderPassword":"ozzy"}'));
	}

	/**
	 * Check explanation of an appropriate target config.
	 */
	@IsTest static void explainTargetConfigurationWithWriteback() {
		System.assertEquals('<p>Using company ID <strong>12</strong> and sender ID <strong>47</strong><p>The VENDORID field will be used as the Intacct unique identifier. Identifiers will be written back to the Intacct_Vendor_Id__c field on the Salesforce record.</p>', new IntacctAdapter().explainTargetConfiguration(context, '{"companyId":"12","senderId":"47","senderPassword":"ozzy","keyField":"VENDORID","writebackField":"Intacct_Vendor_Id__c"}'));
	}

	/**
	 * Set a valid and appropriate target configuration.
	 */
	@IsTest static void setTargetConfiguration() {
		IntacctAdapter adapter = new IntacctAdapter();
		adapter.setTargetConfiguration(context, '{"companyId":"12","senderId":"47","senderPassword":"ozzy","keyField":"VENDORID","writebackField":"Intacct_Vendor_Id__c"}');
		System.assertEquals('47', adapter.SENDER_ID);
		System.assertEquals('ozzy', adapter.SENDER_PASSWORD);
		System.assertEquals('12', adapter.COMPANY_ID);
		System.assertEquals('VENDORID', adapter.targetConfig.keyField);
		System.assertEquals('Intacct_Vendor_Id__c', adapter.targetConfig.writebackField);
	}

	/**
	 * Check the default batch size limit.
	 */
	@IsTest static void getBatchSizeLimit() {
		System.assertEquals(100, new IntacctAdapter().getBatchSizeLimit(context));
	}

	@IsTest static void testSerialization() {

		IntacctAdapter.FetchScope testFetchScope = new IntacctAdapter.FetchScope(7, 12);

		IntacctAdapter adapter = new IntacctAdapter();

		String serialized = adapter.serializeScope(testFetchScope);

		System.assertEquals('{"pageSize":7,"offset":12}', serialized);

		IntacctAdapter.FetchScope deserialized = (IntacctAdapter.FetchScope)adapter.deserializeScope(serialized);

		System.assertEquals(testFetchScope.offset, deserialized.offset);
		System.assertEquals(testFetchScope.pageSize, deserialized.pageSize);
	}
}