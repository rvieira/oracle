# Correct mount options for nfs share for data pump export on 11g
mount -F nfs -o rw,bg,hard,rsize=32768,wsize=32768,vers=3,forcedirectio,nointr,proto=tcp,suid host:/folder1/to1 /folder2/to2