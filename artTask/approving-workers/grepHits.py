import  re
pattern = re.compile("3[\w\d]{29}")

hitIDs = []
for i, line in enumerate(open('hitsList.txt')):
	for match in re.finditer(pattern, line):
        	hitIDs.append(match.group(0))

file = open("allHits.txt", "w+")
for element in hitIDs:
	file.write(str(element)+"\n")
file.close()
