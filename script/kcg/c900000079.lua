local s, id = GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)

	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(12744567,0))
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e9:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e9:SetRange(LOCATION_SZONE)
	e9:SetCode(EVENT_PHASE+PHASE_END)
	e9:SetCountLimit(1)
	e9:SetTarget(s.mtarget)
	e9:SetOperation(s.moperation)
	c:RegisterEffect(e9)

	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(id,0))
	e10:SetType(EFFECT_TYPE_IGNITION)
	e10:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e10:SetRange(LOCATION_SZONE)
	e10:SetCountLimit(1)
	e10:SetTarget(s.mtarget1)
	e10:SetOperation(s.moperation1)
	c:RegisterEffect(e10)

	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(id,1))
	e11:SetType(EFFECT_TYPE_IGNITION)
	e11:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e11:SetRange(LOCATION_SZONE)
	e11:SetCountLimit(1)
	e11:SetTarget(s.mtarget2)
	e11:SetOperation(s.moperation2)
	c:RegisterEffect(e11)
	
	-- local e12=Effect.CreateEffect(c)
	-- e12:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	-- e12:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
	-- e12:SetCode(EVENT_ENTITY_RESET)
	-- e12:SetOperation(s.moperation22)
	-- c:RegisterEffect(e12)

	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_CANNOT_DISABLE)
	c:RegisterEffect(e8)
end
--------------------------------------------------------------------------------------------------
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
---------------------------------------------------------------------------------------------
function s.filter(c)
	return not c:IsType(TYPE_TOKEN) and c:IsType(TYPE_TOON) and c:IsFaceup()
end
function s.mtarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,0,1,20,nil)
end
function s.moperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	for tc in aux.Next(g) do
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,tc)
	end end
end

function s.filter2(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_MONSTER)
end
function s.mtarget1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=e:GetHandler():GetOverlayGroup()
	local count=0
	local tc=g:GetFirst()
	while tc do
		if s.filter2(tc,e,tp) then
			count=count+1
		end
		tc=g:GetNext()
	end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and count>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_OVERLAY)
end
function s.moperation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetOverlayGroup()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:FilterSelect(tp,s.filter2,1,math.min(ft,#g),nil,e,tp)
	if sg:GetCount()<1 then return end
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
end
----------------------------------------------
function s.filter3(c)
	return not c:IsType(TYPE_TOON) and not c:IsSetCard(0x62) and c:IsFaceup()
end
function s.mtarget2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.filter3(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter3,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.filter3,tp,LOCATION_MZONE,0,1,20,nil)
end
function s.moperation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if c:IsRelateToEffect(e) and #g>0 then
		aux.cartoonize(e,tp,g,EFFECT_FLAG_OWNER_RELATE,RESET_EVENT+RESETS_STANDARD)
		for tc in aux.Next(g) do
			if not tc:IsImmuneToEffect(e) then
				c:SetCardTarget(tc)
			end
		end
	end
end
-- function s.moperation22(e,tp,eg,ep,ev,re,r,rp)
-- 	local c=e:GetHandler()
-- 	Duel.SetTargetCard(eg)
-- 	if c:IsRelateToEffect(e) and #eg>0 then
-- 		aux.cartoonize(e,tp,eg,EFFECT_FLAG_OWNER_RELATE,RESET_EVENT+RESETS_STANDARD)
-- 		for tc in aux.Next(eg) do
-- 			if not tc:IsImmuneToEffect(e) then
-- 				c:SetCardTarget(tc)
-- 			end
-- 		end
-- 	end
-- end