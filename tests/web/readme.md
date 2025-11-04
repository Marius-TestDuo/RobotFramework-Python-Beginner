Locator Types if and when to use:	
-CSS Selector	css:[data-test='...']
--Usually faster execution, cleaner syntax, works well with IDs and classes.
--Cannot traverse "up" the DOM tree (parent elements).
-XPath //a[@data-test='...']
--Very flexible, can navigate in any direction, powerful for complex paths.
--Slower execution, verbose syntax, can break easily if the HTML structure changes.