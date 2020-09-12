<!-- Generated with Stardoc: http://skydoc.bazel.build -->

<a id="#buildozer"></a>

## buildozer

<pre>
buildozer(<a href="#buildozer-name">name</a>, <a href="#buildozer-add_tables">add_tables</a>, <a href="#buildozer-buildifier">buildifier</a>, <a href="#buildozer-commands">commands</a>, <a href="#buildozer-delete_with_comments">delete_with_comments</a>, <a href="#buildozer-edit_variables">edit_variables</a>,
           <a href="#buildozer-error_on_no_changes">error_on_no_changes</a>, <a href="#buildozer-format_on_write">format_on_write</a>, <a href="#buildozer-keep_going">keep_going</a>, <a href="#buildozer-prefer_eol_comments">prefer_eol_comments</a>, <a href="#buildozer-quiet">quiet</a>,
           <a href="#buildozer-shorten_labels">shorten_labels</a>, <a href="#buildozer-tables">tables</a>, <a href="#buildozer-types">types</a>)
</pre>



**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="buildozer-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/docs/build-ref.html#name">Name</a> | required |  |
| <a id="buildozer-add_tables"></a>add_tables |  JSON file with custom table definitions which will be merged with the built-in tables   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | optional | None |
| <a id="buildozer-buildifier"></a>buildifier |  A label pointing to an executable buildifier output. Has no meaning unless <code>format_on_write</code> is True   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | optional | None |
| <a id="buildozer-commands"></a>commands |  File to read commands from   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | required |  |
| <a id="buildozer-delete_with_comments"></a>delete_with_comments |  If a list attribute should be deleted even if there is a comment attached to it   | Boolean | optional | True |
| <a id="buildozer-edit_variables"></a>edit_variables |  For attributes that simply assign a variable (e.g. hdrs = LIB_HDRS), edit the build variable instead of appending to the attribute   | Boolean | optional | False |
| <a id="buildozer-error_on_no_changes"></a>error_on_no_changes |  Exit with 3 on success, when no changes were made   | Boolean | optional | False |
| <a id="buildozer-format_on_write"></a>format_on_write |  Set to True for format on write using the -buildifier flag. If the <code>buildifier</code> attribute is empty, use the built-in formatter   | Boolean | optional | False |
| <a id="buildozer-keep_going"></a>keep_going |  Apply all commands, even if there are failures   | Boolean | optional | False |
| <a id="buildozer-prefer_eol_comments"></a>prefer_eol_comments |  When adding a new comment, put it on the same line if possible   | Boolean | optional | True |
| <a id="buildozer-quiet"></a>quiet |  Suppress informational messages   | Boolean | optional | False |
| <a id="buildozer-shorten_labels"></a>shorten_labels |  Convert added labels to short form, e.g. //foo:bar =&gt; :bar   | Boolean | optional | True |
| <a id="buildozer-tables"></a>tables |  JSON file with custom table definitions which will replace the built-in tables   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | optional | None |
| <a id="buildozer-types"></a>types |  List of rule types to change, the default empty list means all rules   | List of strings | optional | [] |


