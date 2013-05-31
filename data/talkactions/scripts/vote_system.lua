	-- Made by Leon Zawodowiec --
function vote_clean() -- Czysci wyniki ostatniego g�osowania
    setGlobalStorageValue(9855, 0) -- Odpowiada, aby tylko 1 g�osowanie by�o naraz
    setGlobalStorageValue(2299, 0) -- Odpowiada za g�osy na TAK
    setGlobalStorageValue(2288, 0) -- Odpowiada za g�osy na NIE
return true
end

function vote_end() -- Og�asza wyniki g�osowania
    doBroadcastMessage("Wyniki Glosowania:")
	doBroadcastMessage("".. getGlobalStorageValue(2299) .. " na TAK !")
	doBroadcastMessage("".. getGlobalStorageValue(2288) .. " na NIE !")
	addEvent(vote_clean, 2000) -- Czy�ci wszystkie wpisy (Aktualne wyniki, g�osowanie)
return true
end

function vote_cancel() -- Anuluje aktualne g�osowanie
	doBroadcastMessage("Glosowanie zostalo anulowane !")
	vote_clean() -- Czy�ci wszystkie wpisy (Aktualne wyniki, g�osowanie)
return true
end

function onSay(cid, words, param) -- G�owna struktura skryptu
	local vote_end_time = 60 -- Czas g�osowania w sekundach

    if getGlobalStorageValue(9855) ~= 1 and getGlobalStorageValue(7200) <= os.time() and words == '/vote' then -- Rozpoczyna g�osowanie
		if words == '/vote' then
            addEvent(vote_end, vote_end_time * 1000) -- Ustawia licznik po kt�rym zako�czy g�osowanie i wy�wietli wyniki
			doBroadcastMessage("UWAGA - GLOSOWANIE !")
			doBroadcastMessage("Pytanie: " .. param .. "")
			doBroadcastMessage("Aby zaglosowac wpisz na czacie:  !tak  lub  !nie")
			vote_clean() -- Zeruje liczniki na pocz�tku
            setGlobalStorageValue(9855, 1) -- Ustawia Global Storage Value aby nie by�o mo�na zacz�� kilku g�osowa� naraz.
			setGlobalStorageValue(7200, os.time() + vote_end_time) -- Ustawia Licznik aby nie by�o mo�na zacz�� nast�pnego g�osowania w kr�tszym odst�pie od "vote_end_time", aby przy anulowaniu g�osowania i rozpocz�ciu kolejnego wszyscy mogli znowu g�osowa�
        end
	else
		if getPlayerAccess(cid) >= 5 and words == '/vote' then
			doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Do nastepnego glosowania musisz odczekac jeszcze " .. getGlobalStorageValue(7200) - os.time() .. " sekund !")
		end
    end
	
    if getGlobalStorageValue(9855) == 1 then -- Je�eli g�osowanie rozpocz�o si�
		if words == '!tak' and getPlayerStorageValue(cid, 7200) <= os.time() then -- Je�eli gracz g�osuje na TAK
			setGlobalStorageValue(2299, getGlobalStorageValue(2299) + 1) -- Dodaje 1 g�os na TAK
			doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Zaglosowales na TAK !")
			setPlayerStorageValue(cid, 7200, os.time() + vote_end_time) -- Ustawia czas w jakim gracz nie mo�e g�osowa�
		elseif words == '!nie' and getPlayerStorageValue(cid, 7200) <= os.time() then
			setGlobalStorageValue(2288, getGlobalStorageValue(2288) + 1) -- Dodaje 1 g�os na TAK
			doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Zaglosowales na NIE !")
			setPlayerStorageValue(cid, 7200, os.time() + vote_end_time) -- Ustawia czas w jakim gracz nie mo�e g�osowa�
		elseif getPlayerStorageValue(cid, 7200) >= os.time() then -- Je�eli gracz pr�buje zag�osowa� w niedozwolonych czasie
			doPlayerSendCancel(cid, "Juz glosowales !")
		end
	else -- Je�eli �adne g�osowanie nie zosta�o rozpocz�te
		doPlayerSendCancel(cid, "Zadne glosowanie nie zostalo rozpoczete !")
	end
return true
end