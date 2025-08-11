--編碼轉換(KCG)
local s, id = GetID()

local isRace = Card.IsRace
function Card.IsRace(c,race,scard,sumtype,playerid)
    if sumtype==nil then sumtype=0 end
    if playerid==nil then playerid=PLAYER_NONE end
    if Duel.GetFlagEffect(0,id)~=0 then 
        return isRace(c,race|Duel.GetFlagEffectLabel(0,id),scard,sumtype,playerid) 
    else 
        return isRace(c,race,scard,sumtype,playerid) 
    end
end

function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end

function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local rc=Duel.AnnounceRace(tp,1,RACE_ALL)
	e:SetLabel(rc)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
    local race=e:GetLabel()
    Duel.RegisterFlagEffect(0,id,RESET_PHASE+PHASE_END,0,1,race)
end