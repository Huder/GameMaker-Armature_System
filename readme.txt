ARMATURE SYSTEM by Jakub Michalski aka Huder

Budowa systemu:

1. Instancja ma zdefiniowany system armatury
2. System posiada zdefiniowane kości
3. System także jest kością (ale kością root, która od niczego nie dziedziczy)
4. System posiada zdefiniowany kontener pose
5. System posiada zdefiniowany podsystem animacji oparty na zdefiniowanych pozach konteneru "pose"

System armatury jest strukturą z konstruktorem o nazwie Armature. "new Armature(...)"
konstruktor wymaga podania: 
- nazwy root bone
- pozycji startowej x i y (względem świata)
- obrotu systemu
- skali systemu

i opcjonalnie:
- sprite kości root
- maskę kości root (ponieważ będzie to instancja o czym później)
- obrót spritu i skalę spritu (to wpływa tylko wygląd grafiki spritu a nie na samo funkcjonowanie systemu)

Kości są instancją o nazwie ARMATURE_BONE
Definicja kości wymaga podania:
- nazwy kości
- nazwy kości po której ma dziedziczyć (jeżeli to nie jest root bone)
- pozycja x i y początku kości
- pozycja x i y końcówki kości
- layer (wymagany do sortowania depth obiektów ARMATURE_BONE)

i opcjonalnie:
- sprite
- maskę 
- obrót sprita i skala sprita
- flaga inheritRotation (o tym niżej)


Kilka kluczowych założeń systemu armatury

- funkcja która tworzy nową kość zawarta jest w zestawie funkcji struktury "Armature"
- instancja która tworzy armaturę może posiadać ich kilka niezależnych
- konstruktor new Armature(...) musi tworzyć instancję ARMATURE_BONE ale ta kość to "root" bo nie dziedziczy po niczym
- ARMATURE_BONE ma zmienną "isRoot" oznaczającą czy dziedziczy po innej kości czy jest "rootem"
- depth kości "root" jest traktowany jako depth wyjściowy (layer 0)
- kości non-root mają depth mniejszy lub większy zgodnie z ustalonym numerem layer. 
	layer -1 oznacza pod kością root, layer 1 oznacza nad kością root 
- kości mogą mieć zdefiniowane zasady ograniczeń obrotu: limit obrotu max i min 
- kość domyślnie dziedziedziczy obrót po rodzicu ale to może być wyłączone flagą "inheritRotation"
- kość posiada funkcję obracania set i add (lokalnie)
- kość posiada funkcję obracania set (world) pod warunkiem że nie jest to "root" bo dla root obrót lokalny i world to ten sam
	przy obrotach zawsze są sprawdzane zasady ograniczeń
- kość zna id instancji, która stworzyły struct new Armature(...)
- kość zna także index struktury Armature którą ją utworzyła
- kości non root (child) mogą zostać odłączone (posiadają taką funkcję), 
	wtedy należy przeliczyć cały system, od teraz odłączona kość i jej dzieci nie znają już indexu struktury Armatury,
	tracą też znajomość id instancji, która stworzyła Armaturę, odłączona kość staje się "rootem" dla swoich dzieci,
- jeżeli jakaś kość zostanie zniszczona to niszczą się także jej dzieci,
	a strukt Armature zostaje o tym powiadomiony aby zaktualizować swoje drzewo "genealogiczne"
- kości same liczą swoje transformacje, nie robi tego struct Armature 	
- ale struct Armature może wysyłać instrukcje animacji rotacji
- kość posiada flagę ignorowania pozy, wtedy też jej dzieci ignorują, 
	dzięki temu można wydzielić dany branch kości z systemu animacji i nią sterować,
	np możliwość celowania do myszki ręką albo ragdoll
	
	