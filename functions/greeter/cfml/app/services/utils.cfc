component {

	/**
	 * Returns true if a struct key exists and it's value has a length
	 *
	 * @structure structure
	 * @key key to check against structure
	 */
	public boolean function structValueIsPresent(required struct struct, required string key) {
		return StructKeyExists(arguments.struct, arguments.key) && !IsEmpty(arguments.struct[arguments.key]);
	}

	/**
	 * Deserialize If JSON
	 *
	 * @string JSON to deserialize (required)
	 * @default Default value to return if false
	 */
	public any function deserializeIfJSON(required any value, any default) {
		local.default = arguments.default ?: arguments.value;
		if (IsEmpty(arguments.value) || IsBoolean(arguments.value)) {
			return local.default;
		}
		if (IsJSON(arguments.value)) {
			return DeserializeJSON(arguments.value);
		}
		return local.default;
	}

}
