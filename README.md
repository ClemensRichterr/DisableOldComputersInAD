# DisableOldComputersInAD

## Story

I wrote this Powershell script because I kept coming across outdated computers or computers that don't even exist physically but are still in the AD, which is annoying if you have, for example, management software that keeps retrieving the computers via LDAP. At the same time, the script also increases security because you don't want to have any outdated computers in the AD in principle.

## Usage

 1. Copy the Powershell script to the domain controller, for example.
 2. Adapt the variables at the beginning of the script to your environment
 3. If you want to check which computers are affected at the beginning, simply comment out the following line with # at the beginning of the line, i.e. as follows.

 ```
#Disable-ADAccount -Identity $item.SamAccountName
```

 4. If necessary, you can also include the script in the task scheduling and let yourself be notified automatically.
 5. Have fun.

## Note of Thanks

Thanks for [www.der-windows-papst.de](https://www.der-windows-papst.de/wp-content/uploads/2017/08/Computer-nach-90-Tagen-automatisch-deaktivieren.pdf) ✌, because this script gave me the inspiration to build something like this!
