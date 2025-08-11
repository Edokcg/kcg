--欧贝利斯克的巨神兵-粉碎(neet)
local s,id=GetID()
function s.initial_effect(c)
	--summon with 3 tribute
	local e1=aux.AddNormalSummonProcedure(c,true,false,3,3,SUMMON_TYPE_TRIBUTE,aux.Stringid(id,0))
	local e2=aux.AddNormalSetProcedure(c)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e3:SetCondition(s.ntcon)
	c:RegisterEffect(e3)
	--Special Summon Token
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(s.sptg)
	e4:SetOperation(s.spop)
	c:RegisterEffect(e4)
	--special summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,2))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCost(s.spcost)
	e5:SetTarget(s.sptg2)
	e5:SetOperation(s.spop2)
	c:RegisterEffect(e5)
end
s.listed_names={10000000,id}
function s.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:GetLevel()>4 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and Duel.GetMatchingGroupCount(aux.TRUE,c:GetControler(),0,LOCATION_MZONE,nil)>=3
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,id+1,0,TYPES_TOKEN,0,0,1,RACE_FAIRY,ATTRIBUTE_DARK)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	--Summon 2 Tokens
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) or Duel.GetLocationCount(tp,LOCATION_MZONE)<2
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,id+1,0,TYPES_TOKEN,0,0,1,RACE_FAIRY,ATTRIBUTE_DARK) then return end
	for i=1,2 do
		local token=Duel.CreateToken(tp,id+1)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
		e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		e3:SetValue(1)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e3,true)
		local e4=e3:Clone()
		e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		token:RegisterEffect(e4,true)
		local e5=e3:Clone()
		e5:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		token:RegisterEffect(e5,true)
	end
	Duel.SpecialSummonComplete()
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function s.filter(c,e,tp)
	return c:IsCode(10000000) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if e:GetHandler():GetSequence()<5 then ft=ft+1 end
	if chk==0 then return ft>0 and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function s.thfilter(c)
	return c:ListsCode(10000000) and not c:IsCode(id) and c:IsAbleToHand()
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if not tc or Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)==0 then return end
	tc:RegisterFlagEffect(id+1,RESET_EVENT+RESETS_STANDARD,0,1)
	if Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #tg>0 then
			Duel.SendtoHand(tg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tg)
		end
	end
	if tc:GetFlagEffect(id)==0 then
		tc:RegisterFlagEffect(id,0,0,1)
		local effs={tc:GetCardEffect()}
		for _,eff in ipairs(effs) do
			local typ=eff:GetType()
			local code=eff:GetCode()
			if typ and typ&EFFECT_TYPE_TRIGGER_F==EFFECT_TYPE_TRIGGER_F and code and code&(EVENT_PHASE+PHASE_END)==(EVENT_PHASE+PHASE_END) then
				local con=eff:GetCondition()
				local e1=eff:Clone()
				e1:SetCondition(s.effcon(con))
				e1:SetType(typ)
				tc:RegisterEffect(e1,true)
				local e2=eff:Clone()
				e2:SetType(typ+EFFECT_TYPE_TRIGGER_O-EFFECT_TYPE_TRIGGER_F)
				e2:SetCondition(s.effcon2(con))
				tc:RegisterEffect(e2,true)

				eff:Reset()
			end
		end
	end
end
function s.effcon(con)
	return function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if c:GetFlagEffect(id+1)>=1 then return false end
		return not con or con(e,tp,eg,ep,ev,re,r,rp,0)
	end
end
function s.effcon2(con)
	return function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if c:GetFlagEffect(id+1)<=0 then return false end
		return not con or con(e,tp,eg,ep,ev,re,r,rp,0)
	end
end