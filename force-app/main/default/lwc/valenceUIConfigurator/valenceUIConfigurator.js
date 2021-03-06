/**
 * Wraps some of the basic functionality of participating in the Valence UI as a custom configuration screen.
 *
 * Extend this class with your own custom component in order to make a Valence UI plugin.
 *
 * There are two methods you must implement in your sub-class:
 *
 * object getDefaultShape()
 * - Return the "default" version of your configuration; what is your base template like? Example: {"style" : "neutral", "runAlways" : false}
 *
 * boolean computeValid()
 * - Return a true/false boolean for whether the current configuration of the component is valid, which allows the User to save it to the server
 *
 * There are several lifecycle hooks you can use if you want to react to properties being set. Otherwise just use connectedCallback() to inspect the properties
 * as you are doing first-time setup on your component.
 *
 * void onSetLink() - fired when the 'link' property is populated
 * void onSetSchema() - fired when the 'schema' property is populated
 * void onSetMapping() - fired when the 'mapping' property is populated
 * void onSetConfiguration() - fired when the 'configuration' property is populated
 * object tweakConfiguration() - allows you to override the configuration that is kicked up the chain, good place to strip any extra stuff you added to it for your own UI purposes
 */

import {api, LightningElement} from 'lwc';

export default class ValenceUIConfigurator extends LightningElement {

	_link = {}; // info about the Link
	_schema = {}; // info about the source and target schemas
	_mapping = {}; // info about the mapping, if this configuration is tied to a single mapping
	_configuration = {}; // the current configuration

	constructor() {
		super();

		if(new.target === 'ValenceUIConfigurator') {
			throw new TypeError('You cannot instantiate ValenceUIConfigurator directly; instead you should extend it.');
		}

		if(this.getDefaultShape === undefined) {
			throw new TypeError('Your Valence UI configurator plugin must implement the getDefaultShape() method, see https://docs.valence.app');
		}

		if(this.computeValid === undefined) {
			throw new TypeError('Your Valence UI configurator plugin must implement the computeValid() method, see https://docs.valence.app');
		}
	}

	get link() {
		return this._link;
	}

	@api set link(newValue) {
		this._link = newValue;
		if(this.onSetLink) {
			this.onSetLink();
		}
	}

	get schema() {
		return this._schema;
	}

	@api set schema(newValue) {
		this._schema = newValue;
		if(this.onSetSchema) {
			this.onSetSchema();
		}
	}

	get mapping() {
		return this._mapping;
	}

	@api set mapping(newValue) {
		this._mapping = newValue;
		if(this.onSetMapping) {
			this.onSetMapping();
		}
	}

	get configuration() {
		return this._configuration;
	}

	/**
	 * Called by Valence to initialize configuration at the start, and also to reset it when the user clicks "Discard Changes"
	 *
	 * @param newConfig
	 */
	@api set configuration(newConfig) {
		this._configuration = newConfig && Object.keys(newConfig).length > 0 ? JSON.parse(JSON.stringify(newConfig)) : this.getDefaultShape();
		if(this.onSetConfiguration) {
			this.onSetConfiguration();
		}
	}

	configUpdated() {
		this.dispatchEvent(new CustomEvent('updateconfig', {
			detail : {
				newValue : this.tweakConfiguration ? this.tweakConfiguration() : this.configuration,
				isValid : this.computeValid()
			}
		}));
	}
}