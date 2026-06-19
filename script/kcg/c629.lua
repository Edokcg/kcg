--ダークネス・ブランブル
--Darkness Bramble
local s,id=GetID()
function s.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,1))
	e0:SetCategory(CATEGORY_SUMMON)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e0:SetCode(EVENT_SUMMON_SUCCESS)
	e0:SetTarget(s.adtg)
	e0:SetOperation(s.adop)
	c:RegisterEffect(e0)

	--Reveal cards
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(s.rvtg)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)

	--lp4000
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(s.lptg)
	e2:SetOperation(s.lpop)
	c:RegisterEffect(e2)

	--battle indestructable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
s.listed_series={0x316}

function s.adfilter(c,tp)
	if not c:IsSetCard(0x316) or c:IsLevelBelow(4) then return false end
	local chk=false
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_RELEASE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
	local eff={}
	local ae={c:IsHasEffect(EFFECT_UNSUMMONABLE_CARD)}
	for _,te in ipairs(ae) do
		table.insert(eff,te)
		te:Reset()
	end
	local type=c:GetOriginalType()
	local te2=c:SetCardData(CARDDATA_TYPE,type&~TYPE_SPSUMMON,0,RESET_CHAIN,c)
	-- local ae2={c:IsHasEffect(EFFECT_REVIVE_LIMIT)}
	-- for _,te in ipairs(ae2) do
	-- 	table.insert(eff,te)
	-- 	te:Reset()
	-- end
	chk=(c:IsSummonable(true,nil,1) or c:IsMSetable(true,nil,1))
	e1:Reset()
	for _,te in ipairs(eff) do
		c:RegisterEffect(te)
	end
	te2:Reset()
	return chk
end
function s.adtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.adfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function s.adop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,s.adfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_EXTRA_RELEASE)
		e1:SetTargetRange(0,LOCATION_MZONE)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_CHAIN)
		Duel.RegisterEffect(e1,tp)
		local eff={}
		local ae={tc:IsHasEffect(EFFECT_UNSUMMONABLE_CARD)}
		if ae then
			for _,te in ipairs(ae) do
				table.insert(eff,te)
				te:Reset()
			end
		end
		local type=tc:GetOriginalType()
		local te2=tc:SetCardData(CARDDATA_TYPE,type&~TYPE_SPSUMMON,0,RESET_CHAIN,tc)
		local s1=tc:IsSummonable(true,nil,1)
		local s2=tc:IsMSetable(true,nil,1)
		if (s1 and s2 and Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) or not s2 then
			Duel.Summon(tp,tc,true,nil,1)
		else
			Duel.MSet(tp,tc,true,nil,1)
		end
		tc:CompleteProcedure()
		for _,te in ipairs(eff) do
			tc:RegisterEffect(te)
		end
		te2:Reset()
	end
end

function s.rvtg(e,tp,ev,ep,ev,re,r,rp,chk)
	if chk==0 then
		local gdd=Duel.GetFieldGroup(tp,LOCATION_SZONE,0)
		if gdd:GetCount()<1 then return false end
		local gd=gdd:Filter(Card.IsFacedown,nil)
		return gd:GetCount()>0
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local gdd=Duel.GetFieldGroup(tp,LOCATION_SZONE,0)
	if gdd:GetCount()<1 then return end
	local gd=gdd:Filter(Card.IsFacedown,nil)
	if #gd>0 then Duel.ConfirmCards(tp, gd) end
end

function s.lptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLP(tp)<4000 end
	Duel.SetTargetPlayer(tp)
end
function s.lpop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.SetLP(p,4000)
end