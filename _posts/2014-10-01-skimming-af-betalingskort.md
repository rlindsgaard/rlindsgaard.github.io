---
title: Skimming af betalingskort
layout: post
---

Der er faldet dom om [en dansk mand som har "skimmet" betalingskort](http://politiken.dk/indland/ECE2412101/21-aarig-skimmede-betalingskort-i-torvehallerne)

Skimming betyder kort fortalt at man læser informationerne på et kort, og kopierer kortet som artiklen også beskriver.

Det den ikke nævner er hvordan det foregår i praksis. Sagen er den at vi på betalingskort i Danmark har både en magnetstribe og en chip. Data på chippen ligger krypteret og er i praksis sikker, da den ikke bare lige kan blive kopieret. Dette gælder ikke for magnetstriben - tvært imod. Der ligger de samme data på magnetstriben som der ligger på kortet, forskellen er bare at de ikke er krypterede. Der skal utroligt billig hardware til at kopiere et kort, og det kan gøres meget meget nem. Det er faktisk så grelt at der findes hardware som kan indsættes i en hæveautomat, og er utroligt billigt.

Hvad værre er, at man ikke behøver en pinkode for at kunne misbruge dette. Den måde kommunikationen fungerer på er at der fra automaten bliver sendt en enkelt bit afsted til Nets som fortæller om automaten skal have pinkode eller ej. Det kræver derfor bare at forbryderen har en ven med lidt teknisk snilde som arbejder et sted med en automat der er til at konfigurere.

Magnetstriben er i dag ikke nødvendig for at udføre betalinger, og hvis man vil sikre sig mod denne slags handler det såre enkelt om at fjerne hvad der ligger på magnetstriben. Man kan fjerne den fysisk, men en bedre metode er at få fat på en tilpads kraftig magnet og stryge hen over magnetstriben nok gange. Du kan tjekke om det er gjort ordentligt ved at forsøge at betale med magnetstriben næste gang du handler i netto.
