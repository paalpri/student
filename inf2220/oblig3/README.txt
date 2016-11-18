README

Metoden min fjerner alle wildcards som er i slutten av metoden, siden jeg trenger ikke teste disse. Må bare ta vekk så mange i haystacken so jeg tar vekk fra needelen. På denne måten passer jeg på at needelen eg lang nok når jeg tester den mot haystacken.
Lager så en annen array som inneholder indexen til alle tegn som ikke er wildcards, så i selve hoved for loopen så tester jeg bare needle[index] sånn at jeg ikke tester for wildcards men bare spesielle tegn. visst needelen bare inneholder wildcards så gidder jeg ikke teste mot haystacken engang, siden den er overalt.

Legger ved needle.txt og haystack.txt med en needle og haystack jeg testet litt med, bare å endre disse visst du vil teste andre tilfeller.

compile: javac *.java
         run: java oblig3 needle.txt haystack.txt

Main ligger i oblig3.java
basic boyyer_moore_horspool er tatt fra forelesning.

alt funker perfect.

Make linux great again!
- pål out! 
