ps -ef | grep pmon | grep asm | awk -F_ '{print $3}'
echo $(ps -ef | awk '/[o]racle.*(asm|ASMB)/ {print $NF}' | cut -d'_' -f3)


