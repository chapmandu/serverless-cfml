component extends="tests.Test" {

	function setup() {
		utils = new functions.greeter.cfml.app.services.utils();
		super.setup();
	}

	function teardown() {
		super.teardown();
	}

	function test_deserializeIfJSON_returns_struct() {
		actual = utils.deserializeIfJSON('{"foo": "bar"}');
		assert(actual.foo == "bar");
	}

	function test_deserializeIfJSON_returns_false() {
		actual = utils.deserializeIfJSON('foo');
		expected = "foo";
		assert(actual == expected);
	}

	function test_deserializeIfJSON_returns_default() {
		actual = utils.deserializeIfJSON('foo', {});
		assert(StructIsEmpty(actual));
	}

	function test_deserializeIfJSON_with_boolean() {
		actual = utils.deserializeIfJSON(false, {});
		assert(StructIsEmpty(actual));
	}

	function test_deserializeIfJSON_with_empty_string() {
		actual = utils.deserializeIfJSON("", {});
		assert(StructIsEmpty(actual));
	}

	function test_deserializeIfJSON_returns_non_json_value() {
		actual = utils.deserializeIfJSON(["foo"]);
		assert(actual[1] == "foo");
	}

}
