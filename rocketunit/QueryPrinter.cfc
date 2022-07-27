/*
	MIT License

	Copyright (c) 2022 Ben Nadel

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.

	https://www.bennadel.com/blog/3801-pretty-printing-a-coldfusion-query-object-in-lucee-cfml-5-2-9-31.htm
*/
component
	output=false
	hint="I provide methods for serializing a Query object for output using a MySQL-CLI inspired fixed-width format."
{

	/**
	 * I serialize and return the given query using a MySQL-CLI inspired fixed-width
	 * format.
	 *
	 * @records I am the query being serialized.
	 * @columnNames I am the OPTIONAL list of columnNames to include in the serialization.
	 * @newline I am the OPTIONAL string of characters used to separate lines of output.
	 * @maxValueLength I am the OPTIONAL length at which to truncate column values.
	 */
	public string function toString(
		required query records,
		array columnNames = records.columnArray(),
		string newline = Chr(10),
		numeric maxValueLength = 0
	) {
		var columnWidths = getMaxWidths(columnNames, maxValueLength, records);
		var hrule = getHrule(columnWidths);

		// Each header / record within the query will be serialized into a temporary
		// buffer, which will then be collapsed into a single string-value at the end.
		var buffer = [hrule, serializeHeader(columnNames, columnWidths, maxValueLength), hrule];

		for (var row in records) {
			buffer.append(serializeRow(columnNames, columnWidths, maxValueLength, row));
		}

		buffer.append(hrule);

		return (buffer.toList(newline));
	}

	// ---
	// PRIVATE METHODS.
	// ---

	/**
	 * I collapse the given array of values using the given joiners and wrappers.
	 *
	 * @values I am the array being collapsed.
	 * @prefix I am the prefix for the serialized values.
	 * @infix I am the infix for the serialized values.
	 * @suffix I am the suffix for the serialized values.
	 */
	private string function collapseValues(
		required array values,
		required string prefix,
		required string infix,
		required string suffix
	) {
		return (prefix & values.toList(infix) & suffix);
	}


	/**
	 * I generate the horizontal-rule for given column widths.
	 *
	 * @columnWidths I am the width of each column being spanned by the hrule.
	 */
	private string function getHrule(required array columnWidths) {
		var columnValues = columnWidths.map((width) => {
			return ("-".repeatString(width));
		});

		return (collapseValues(columnValues, "+-", "-+-", "-+"));
	}


	/**
	 * I return the max width of the values in each of the given columns.
	 *
	 * @columnNames I am the list of columns to visit.
	 * @maxValueLength I am the length at which column values will be truncated.
	 * @records I am the query being inspected.
	 */
	private array function getMaxWidths(
		required array columnNames,
		required numeric maxValueLength,
		required query records
	) {
		var maxWidths = columnNames.map((columnName) => {
			var maxWidth = columnName.len();

			// Iterate over each row in the given column, looking for the longest
			// value - we'll worry about truncation afterwards.
			for (var value in records.columnData(columnName)) {
				maxWidth = Max(maxWidth, ToString(value).len());
			}

			// Truncation should only be applied if the maxValueLength is non-ZERO.
			if (maxValueLength) {
				return (Min(maxWidth, maxValueLength));
			} else {
				return (maxWidth);
			}
		});

		return (maxWidths);
	}


	/**
	 * I serialize and return the given column headers.
	 *
	 * @columnNames I am the list of columns to visit.
	 * @columnWidths I am the width at which to print each corresponding column.
	 * @maxValueLength I am the length at which column values will be truncated.
	 */
	private string function serializeHeader(
		required array columnNames,
		required array columnWidths,
		required numeric maxValueLength
	) {
		var values = columnNames.map((columnName, i) => {
			var value = columnName.ljustify(columnWidths[i]);

			return (truncate(value, maxValueLength));
		});

		return (collapseValues(values, "| ", " | ", " |"));
	}


	/**
	 * I serialize and return the given data-row.
	 *
	 * @columnNames I am the list of columns to visit.
	 * @columnWidths I am the width at which to print each corresponding column.
	 * @maxValueLength I am the length at which column values will be truncated.
	 * @data I am the row data being serialized.
	 */
	private string function serializeRow(
		required array columnNames,
		required array columnWidths,
		required numeric maxValueLength,
		required struct data
	) {
		var values = columnNames.map((columnName, i) => {
			var value = ToString(data[columnName]).ljustify(columnWidths[i]);

			return (truncate(value, maxValueLength));
		});

		return (collapseValues(values, "| ", " | ", " |"));
	}


	/**
	 * I truncate the given value at the given length.
	 *
	 * @value I am the value being truncated.
	 * @maxValueLength I am the length at which the value should be truncated.
	 */
	private string function truncate(required string value, required numeric maxValueLength) {
		// Truncation should only be applied if the maxValueLength is non-ZERO. As such,
		// if there is not length supplied, return the given value as-is.
		if (!maxValueLength) {
			return (value);
		}

		var valueLength = value.len();

		if (valueLength <= maxValueLength) {
			return (value);
		}

		var ellipsis = "...";
		var ellipsisLength = ellipsis.len();

		// When truncating, we want to append the ellipsis; however, we can only do this
		// if there is enough VALUE to afford both the truncation and the ellipsis. If
		// not, we just have to perform a hard-truncation of the value.
		if (
			(valueLength <= ellipsisLength) ||
			(maxValueLength <= ellipsisLength)
		) {
			return (value.left(maxValueLength));
		}

		return (value.left(maxValueLength - ellipsisLength) & ellipsis);
	}

}
