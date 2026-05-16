---
title: FEAT:🚩 OverTheWire 「Leviathan | Level 4 -> 7」
date: 2026-05-16 17:13:00 +0900
categories: [CyberSecurity, CTF]
tags: [over_the_wire, linux, rev]
---

## Level 4 -> 5

```shell
leviathan4@leviathan:~$ ll
total 24
drwxr-xr-x   3 root root       4096 Apr  3 15:19 ./
drwxr-xr-x 150 root root       4096 Apr  3 15:20 ../
-rw-r--r--   1 root root        220 Mar 31  2024 .bash_logout
-rw-r--r--   1 root root       3851 Apr  3 15:10 .bashrc
-rw-r--r--   1 root root        807 Mar 31  2024 .profile
dr-xr-x---   2 root leviathan4 4096 Apr  3 15:19 .trash/

leviathan4@leviathan:~$ cd .trash

leviathan4@leviathan:~/.trash$ ll
total 24
dr-xr-x--- 2 root       leviathan4  4096 Apr  3 15:19 ./
drwxr-xr-x 3 root       root        4096 Apr  3 15:19 ../
-r-sr-x--- 1 leviathan5 leviathan4 14944 Apr  3 15:19 bin*

leviathan4@leviathan:~/.trash$ file ./bin
./bin: setuid ELF 32-bit LSB executable, Intel 80386, version 1 (SYSV), dynamically linked, interpreter /lib/ld-linux.so.2, BuildID[sha1]=da2bc992d78bb31f01fa19c9fd0e6d02c042a757, for GNU/Linux 3.2.0, not stripped

leviathan4@leviathan:~/.trash$ checksec --file=./bin
RELRO           STACK CANARY      NX            PIE             RPATH      RUNPATH      Symbols         FORTIFY Fortified       Fortifiable     FILE
Partial RELRO   No canary found   NX enabled    No PIE          No RPATH   No RUNPATH   41 Symbols        No    0      1./bin

leviathan4@leviathan:~/.trash$ ./bin
00110000 01100100 01111001 01111000 01010100 00110111 01000110 00110100 01010001 01000100 00001010
```

`bin` バイナリが出力した2進数をAsciiに変換すると `0dyxT7F4QD` となります．

<details>
<summary>Level5 Password</summary>
0dyxT7F4QD
</details>

## Level 5 -> 6

プログラムが，`/tmp/file.log` という存在しないファイルを読みに行っているため，`ln -s` で `/etc/leviathan_pass/leviathan6` にシンボリックリンクを張ることでパスワードを入手できました．

```shell
$ ssh -p 2223 leviathan5@leviathan.labs.overthewire.org

leviathan5@leviathan:~$ ll
total 36
drwxr-xr-x   2 root       root        4096 Apr  3 15:19 ./
drwxr-xr-x 150 root       root        4096 Apr  3 15:20 ../
-rw-r--r--   1 root       root         220 Mar 31  2024 .bash_logout
-rw-r--r--   1 root       root        3851 Apr  3 15:10 .bashrc
-r-sr-x---   1 leviathan6 leviathan5 15148 Apr  3 15:19 leviathan5*
-rw-r--r--   1 root       root         807 Mar 31  2024 .profile

leviathan5@leviathan:~$ file leviathan5
leviathan5: setuid ELF 32-bit LSB executable, Intel 80386, version 1 (SYSV), dynamically linked, interpreter /lib/ld-linux.so.2, BuildID[sha1]=a8ca96973d1fd3f77428969afe27c79ba5bd560f, for GNU/Linux 3.2.0, not stripped

leviathan5@leviathan:~$ checksec --file=leviathan5
RELRO           STACK CANARY      NX            PIE             RPATH      RUNPATH      Symbols         FORTIFY Fortified       Fortifiable     FILE
Partial RELRO   No canary found   NX enabled    No PIE          No RPATH   No RUNPATH   46 Symbols        No    0      0leviathan5

leviathan5@leviathan:~$ ltrace ./leviathan5
__libc_start_main(0x804910d, 1, 0xffffd464, 0 <unfinished ...>
fopen("/tmp/file.log", "r")                                               = 0
puts("Cannot find /tmp/file.log"Cannot find /tmp/file.log
)                                         = 26
exit(-1 <no return ...>
+++ exited (status 255) +++

leviathan5@leviathan:~$ ln -s /etc/leviathan_pass/leviathan6 /tmp/file.log

leviathan5@leviathan:~$ ./leviathan5
szo7HDB88w
```

<details>
<summary>Level6 Password</summary>
szo7HDB88w
</details>

## Level 6 -> 7

```shell
$ ssh -p 2223 leviathan6@leviathan.labs.overthewire.org

leviathan6@leviathan:~$ ll
total 36
drwxr-xr-x   2 root       root        4096 Apr  3 15:19 ./
drwxr-xr-x 150 root       root        4096 Apr  3 15:20 ../
-rw-r--r--   1 root       root         220 Mar 31  2024 .bash_logout
-rw-r--r--   1 root       root        3851 Apr  3 15:10 .bashrc
-r-sr-x---   1 leviathan7 leviathan6 15040 Apr  3 15:19 leviathan6*
-rw-r--r--   1 root       root         807 Mar 31  2024 .profile
leviathan6@leviathan:~$ file leviathan6
leviathan6: setuid ELF 32-bit LSB executable, Intel 80386, version 1 (SYSV), dynamically linked, interpreter /lib/ld-linux.so.2, BuildID[sha1]=0c0b3db9e6294882dfadf08193312c6c9b6a46ff, for GNU/Linux 3.2.0, not stripped

leviathan6@leviathan:~$ checksec --file=leviathan6
RELRO           STACK CANARY      NX            PIE             RPATH      RUNPATH      Symbols         FORTIFY Fortified       Fortifiable     FILE
Partial RELRO   No canary found   NX enabled    No PIE          No RPATH   No RUNPATH   43 Symbols        No    0      1leviathan6
```

ghidraでデコンパイルすると，`0x1bd3` と入力された数値が一致しているかを確かめていました．`0x1bd3` は `7123` なため，入力するとパスワード入手できました．

```shell
$ scp -P 2223 leviathan6@leviathan.labs.overthewire.org:/home/leviathan6/leviathan6 ./

leviathan6@leviathan:~$ ./leviathan6 7123

$ whoami
leviathan7

$ cat /etc/leviathan_pass/leviathan7
qEs5Io5yM8
```

<details>
<summary>Level7 Password</summary>
qEs5Io5yM8
</details>

## Level 7 (Clear)

```shell
$ ssh -p 2223 leviathan7@leviathan.labs.overthewire.org

leviathan7@leviathan:~$ ll
total 24
drwxr-xr-x   2 root       root       4096 Apr  3 15:19 ./
drwxr-xr-x 150 root       root       4096 Apr  3 15:20 ../
-rw-r--r--   1 root       root        220 Mar 31  2024 .bash_logout
-rw-r--r--   1 root       root       3851 Apr  3 15:10 .bashrc
-r--r-----   1 leviathan7 leviathan7  178 Apr  3 15:19 CONGRATULATIONS
-rw-r--r--   1 root       root        807 Mar 31  2024 .profile

leviathan7@leviathan:~$ file CONGRATULATIONS
CONGRATULATIONS: ASCII text
```