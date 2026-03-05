# Algoritmizace - úkol
## Autor: Tomáš Chabada
## Zadání:
Je dána posloupnost celých čísel délky N.
a) Určete v posloupnosti délku maximálního souvislého vybalancovaného úseku (= úseku, který obsahuje stejný počet kladných a záporných čísel).
b) Najděte v posloupnosti maximální souvislý vybalancovaný úsek, tzn. určete pozici jeho začátku a konce.
c) Vypište maximální souvislý vybalancovaný úsek posloupnosti, tzn. vypište prvky posloupnosti, které ho tvoří.
## Úvaha
Z hlediska algoritmizace stačí řešit pouze úlohu B. Řešení úlohy A je triviální (rozdíl indexů z úlohy B) a úloha C je prakticky výhradně věcí syntaxe jazyka. Úloha má smysl pro pole délky 2 a větší, pro jednoprvkové pole nemá smysl (žádný balancovaný úsek neexistuje).

# Algoritmus 1 (hrubá síla)
V poli budeme postupně zkoušet všechny podposloupnosti a zkoumat, zda jsou vybalancované. Zkoušet budeme jen ty se sudou délkou (lichá délka nemůže být balancovanou nikdy). Zvolíme si délku a vyzkoušíme všechny podposloupnosti (1..D, 2..D+1, 3..D+2 atd., až dokud D+offset nepřekročí délku pole). Každou podposloupnost otestujeme na počet kladných a záporných čísel a při shodě máme řešení, při neshodě zkusíme další podposloupnost a pokud žádnou shodu nenalezneme, zmenšíme délku o 2 a postup opakujeme. Pokud nenalezneme nic ani na délce 2, balancovaná podposloupnost neexistuje a vypíšeme nulu.
**Prostorová složitost** je O(N) (máme jen pole ze zadání a pár proměnných s konstantní délkou).
**Časová složitost** je O(N^3). Možných délek podposloupnosti je obecně N, možností kam podposloupnost "umístit" (kde začne) je taktéž obecně N a otestovat podposloupnost vyžaduje jí projít, což je práce opět v čase řádově N.
# Algoritmus 2 (prefix + hrubá síla)
# Algoritmus 3 (prefixové součty)
Předpoklad vychází z toho, že pokud dva indexy v poli mají stejný prefixový součet (tj. součet všech znamének předchozích čísel, kladné a nula nechť je 1, záporné nechť je -1), tyto indexy tvoří indexy balancované podposloupnosti (protože se prefixové součty rovnají, "mezi" nimi musel být stejný počet plus a minus jedniček). Pole prefixových součtů volíme tak, že index v poli prefixových součtů je prefixový součet a hodnota je index v poli čísel ze zadání. Délka pole prefixových součtů je od -N do N (vyšší ani menší nemůže prefixový součet být, mezní případy jsou "všechna kladná čísla na vstupu" a "všechna záporná čísla na vstupu". Pole zadání projdeme, počítáme prefixový součet (od začátku) a koukáme se, jestli je v poli prefixových součtů. Pokud není (značím výchozí hodnotou -2), tak ho tam přidáme. Pokud je, tak podle hodnoty víme, kde byl a tím máme index balancované podposloupnosti (začátek je hodnota v poli prefixových součtů a konec je aktuální index v cyklu, kterým procházíme pole ze zadání). Tu jen stačí porovnat s dosavadní nejdelší na délku a případně nahradit, pokud je delší. Nulu jako prefixový součet umístíme "před pole" (o 1 menší, než nejmenší index v poli zadání, běžně to bude -1, pro některé jazyky 0).
**Prostorová složitost** je O(N) (máme jen pole ze zadání, pole prefixových součtů o dvojnásobn délce pole ze zadání a pár proměnných s konstantní délkou).
**Časová složitost** je O(N). Pole ze zadání procházíme jen jednou, pole prefixových součtů neprocházíme nikdy.
