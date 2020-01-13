# Single JOIN example
SELECT 
    title, title_id
FROM
    titles AS title
        LEFT JOIN
    titleauthor AS author ON title_id = title_id;
    
# Books with author but title is duplicated due to JOIN
SELECT 
    t.title, t.title_id, a.au_id, CONCAT(au.au_fname, ' ', au.au_lname) as completename
FROM
    titles AS t
	LEFT JOIN titleauthor AS a
		ON t.title_id = a.title_id
    LEFT JOIN authors AS au
		ON a.au_id = au.au_id;
    
# Books with complete author names and year, title duplication is removed with GROUP BY
SELECT 
		title, 
        year(max(pubdate)) as "year",
        count(titleauthor.title_id) as numautores,
        group_concat(concat(authors.au_fname,' ', authors.au_lname))
	FROM titles
	LEFT JOIN titleauthor
		ON titles.title_id = titleauthor.title_id
	LEFT JOIN authors
		ON authors.au_id = titleauthor.au_id
    GROUP BY titles.title
    ORDER BY numautores DESC;


# Alias
SELECT q.title FROM publis.titles as  q;

# Mutliple JOINs
SELECT titleauthor.au_id, titles.title FROM titleauthor 
	LEFT JOIN titles ON titleauthor.title_id = titles.title_id
	RIGHT JOIN titles ON titleauthor.title_id = titles.title_id;
    
# Concatenate string columns
SELECT CONCAT(au_lname, " ", au_fname) AS FullName FROM authors;

# Multiple joins grouped by title with concatenated authors
SELECT title, GROUP_CONCAT(CONCAT(au_lname, " ", au_fname) SEPARATOR ", "), count(*)
FROM titles as t 
	INNER JOIN titleauthor as ta ON t.title_id = ta.title_id
    INNER JOIN authors as au ON ta.au_id = au.au_id
    GROUP BY t.title;
    
# Union
SELECT  au_id, city as m FROM authors WHERE state="IN"
UNION
SELECT au_id, royaltyper as m FROM  titleauthor;


# Subquery
SELECT stor_id, m.title, m.title_id, payterms  FROM sales 
INNER JOIN titles as m ON sales.title_id = m.title_id
WHERE payterms != "Net 30" 
	AND  m.title_id IN (
		SELECT titles.title_id FROM sales 
		INNER JOIN titles ON sales.title_id = titles.title_id
		WHERE payterms = "Net 30"
	);
