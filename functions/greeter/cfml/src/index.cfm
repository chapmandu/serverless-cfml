<!--- an example of returning content, this could be HTML --->
<cfoutput>#SerializeJSON({"lucee": server.lucee, "context": getLambdaContext()})#</cfoutput>
