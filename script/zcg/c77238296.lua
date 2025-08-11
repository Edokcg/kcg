--千年称(ZCG)
function c77238296.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(c77238296.target)
    e1:SetOperation(c77238296.activate)
    c:RegisterEffect(e1)

    --battle indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e2:SetCountLimit(2)
	e2:SetValue(c77238296.valcon)
	c:RegisterEffect(e2)

    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e3:SetCategory(CATEGORY_SEARCH)
    e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetTarget(c77238296.tar)
    c:RegisterEffect(e3)
end

function c77238296.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and
        Duel.IsPlayerCanSpecialSummonMonster(tp,e:GetHandler():GetCode(),nil,0x11,0,0,0,0,0,POS_FACEUP) end
	e:GetHandler():SetTurnCounter(0)	
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

function c77238296.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
        or not Duel.IsPlayerCanSpecialSummonMonster(tp,e:GetHandler():GetCode(),nil,0x11,0,0,0,0,0,POS_FACEUP) then return end
    c:AddMonsterAttribute(TYPE_EFFECT+TYPE_SPELL)
    Duel.SpecialSummon(c,1,tp,tp,true,false,POS_FACEUP)
end

function c77238296.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end

function c77238296.tar(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if not Duel.IsPlayerCanDiscardDeck(1-tp,3) then return false end
		local g=Duel.GetDecktopGroup(1-tp,3)
		return g:FilterCount(Card.IsAbleToHand,nil)>0
	end
	c77238296.announce_filter={TYPE_EXTRA,OPCODE_ISTYPE,OPCODE_NOT}
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac1=Duel.AnnounceCard(tp,table.unpack(c77238296.announce_filter))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac2=Duel.AnnounceCard(tp,table.unpack(c77238296.announce_filter))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac3=Duel.AnnounceCard(tp,table.unpack(c77238296.announce_filter))
	e:SetOperation(c77238296.retop(ac1,ac2,ac3))
end
function c77238296.hfilter(c,code1,code2,code3)
	return c:IsCode(code1,code2,code3) and c:IsAbleToHand()
end
function c77238296.retop(code1,code2,code3)
	return
		function (e,tp,eg,ep,ev,re,r,rp)
			if not Duel.IsPlayerCanDiscardDeck(1-tp,3) then return end
			local c=e:GetHandler()
			Duel.ConfirmDecktop(1-tp,3)
			local g=Duel.GetDecktopGroup(1-tp,3)
			local hg=g:Filter(c77238296.hfilter,nil,code1,code2,code3)
			g:Sub(hg)
			if #hg~=0 then
				Duel.DisableShuffleCheck()
				Duel.SendtoHand(hg,nil,REASON_EFFECT)
				Duel.ConfirmCards(tp,hg)
				Duel.ShuffleHand(tp)
			end
			if #g~=0 then
				Duel.DisableShuffleCheck()
				Duel.SendtoGrave(g,REASON_EFFECT+REASON_REVEAL)
			end
            if #hg==3 and #g==0 then
                Duel.Destroy(c, REASON_EFFECT)
            else
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
			    local dis=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,zone)
			    Duel.MoveSequence(c,math.log(dis,2))
            end
		end
end