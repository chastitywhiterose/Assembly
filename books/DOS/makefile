source=Assembly-Arithmetic-Algorithms-DOS.md

title="Assembly Arithmetic Algorithms"
subtitle="16-bit DOS Edition"
author="Chastity White Rose"

Make-Ebook:
	pandoc $(source) -o ebook.epub -s --metadata title=$(title) --metadata subtitle=$(subtitle) --metadata author=$(author)
docx:
	pandoc $(source) -o book.docx --reference-doc custom-reference.docx
odt:
	pandoc $(source) -o book.odt --reference-doc custom-reference.odt
html:
	pandoc $(source) -o book.html
html-book:
	pandoc $(source) -o book.html -s --metadata title=$(title) --metadata subtitle=$(subtitle) --metadata author=$(author)
