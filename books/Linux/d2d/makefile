source=d2d-Assembly-Arithmetic-Algorithms-Linux.md

title="Assembly Arithmetic Algorithms"
subtitle="32-bit Linux Edition"
author="Chastity White Rose"

Make-Ebook:
	pandoc -t epub3 $(source) -o ebook.epub -s --metadata title=$(title) --metadata subtitle=$(subtitle) --metadata author=$(author)
odt:
	pandoc $(source) -o book.odt --reference-doc custom-reference-7x10.odt
docx:
	pandoc $(source) -o book.docx --reference-doc custom-reference.docx
html:
	pandoc $(source) -o book.html
html-book:
	pandoc $(source) -o book.html -s --metadata title=$(title) --metadata subtitle=$(subtitle) --metadata author=$(author)
