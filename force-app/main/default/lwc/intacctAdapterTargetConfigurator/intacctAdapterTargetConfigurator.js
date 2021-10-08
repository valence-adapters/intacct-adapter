/**
 * Allows for configurator of the Valence Intacct Adapter.
 */

import ValenceUIConfigurator from 'c/valenceUIConfigurator';

export default class IntacctAdapterTargetConfigurator extends ValenceUIConfigurator {

	keyFields = [];
	writebackFields = [];

	// ------------------------------------------
	// ----- Configurator Lifecycle Methods -----
	// ------------------------------------------

	/**
	 * Set up our fieldList whenever we are given schema
	 */
	onSetSchema() {
		console.log('setSchema: ', JSON.parse(JSON.stringify(this.schema)));

		if(!this.schema) {
			return;
		}

		// set up selection options for the Intacct identifier create/update key field
		this.keyFields = [];
		Object.values(this.schema.Target.children).forEach((node) => {
			this.keyFields.push({'value' : node.field.fieldName, 'label' : this.prettyFieldLabel(node.field.fieldName, node.field.fieldLabel)});
			// note: we deliberately ignored any nested schema fields as they are unlikely to be writeable or usable as the unique identifier
		});
		this.keyFields.sort((a, b) => a.value.localeCompare(b.value));

		// set up selections for the Salesforce writeback field
		this.writebackFields = [{'value' : '--noSelection--', 'label' : '-- None --'}];
		Object.values(this.schema.Source.children).forEach((node) => {
			if(node.field.isEditable) {
				this.writebackFields.push({'value' : node.field.fieldName, 'label' : this.prettyFieldLabel(node.field.fieldName, node.field.fieldLabel)});
			}
			// note: we deliberately ignored any nested schema fields as they are unlikely to be writeable or usable as the unique identifier
		});
		this.writebackFields.sort((a, b) => a.value === '--noSelection--' ? -1 : a.value.localeCompare(b.value));
	}

	prettyFieldLabel(name, label) {
		return name + (name !== label && label ? ' (' + label + ')' : '');
	}

	// -------------------------------------------
	// ----- User Manipulating Configuration -----
	// -------------------------------------------

	keyChange(event) {
		this.configuration.keyField = event.target.value;
		this.configUpdated(); // propagate our configuration changes
	}

	writebackChange(event) {
		this.configuration.writebackField = event.target.value === '--noSelection--' ? null : event.target.value;
		this.configUpdated(); // propagate our configuration changes
	}

	// -----------------------------------------
	// ----- Required Configurator Methods -----
	// -----------------------------------------

	getDefaultShape() {
		return {keyField : 'RECORDNO', writebackField : null};
	}

	computeValid() {
		return true; // always valid
	}
}