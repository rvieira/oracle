# Correct mount options for nfs share for data pump export on 11g
# ORA-27054: NFS File System Where the File is Created or Resides is Not Mounted With Correct Options (Doc ID 781349.1)
mount -F nfs -o rw,bg,hard,rsize=32768,wsize=32768,vers=3,forcedirectio,nointr,proto=tcp,suid host:/folder1/to1 /folder2/to2