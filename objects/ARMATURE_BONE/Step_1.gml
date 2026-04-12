/// @description 

/* kość bez systemu armatury aktualizuje się sama 
     w przeciwnym wypadku aktualizacja nastepuje na rozkaz systemu */
if ( system_struct == undefined )
{
    autoUpdate = true;
}
else 
{
	autoUpdate = false;
}