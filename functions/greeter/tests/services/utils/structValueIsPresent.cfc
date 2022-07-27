component extends="tests.Test" {

	function setup() {
		utils = new functions.greeter.cfml.app.services.utils();
		super.setup();
		empties = {string: "", struct: {}, array: [], query: QueryNew("id")};
		fulls = {string: "hello", struct: {hello: "world"}, array: ["hello"], query: QueryNew("id", "varchar", [{id: 666}])};
	}

	function teardown() {
		super.teardown();
	}

	function test_structValueIsPresent_with_no_key_returns_false() {
		actual = utils.structValueIsPresent({}, "foo");
		expected = false;
		assert(actual == expected);
	}

	function test_structValueIsPresent_with_empties_returns_false() {
		cfloop(collection = empties, item = "key") {
			actual = utils.structValueIsPresent(empties, key);
			expected = false;
			assert(actual == expected);
		}
	}

	function test_structValueIsPresent_with_fulls_returns_true() {
		cfloop(collection = fulls, item = "key") {
			actual = utils.structValueIsPresent(fulls, key);
			expected = true;
			assert(actual == expected);
		}
	}

}
