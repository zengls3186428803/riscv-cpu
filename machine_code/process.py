import re

f = open("final_hex.txt", "r")
s = f.read()
f.close()
s_list = re.findall(pattern="[0123456789abcdefABCDEF]{8,8}", string=s)
s_list = s_list[2:]
s = ""
for i in s_list:
    s = s + i + "\n"
print(s)
f = open("final_hex.txt", "w")
f.write(s)

