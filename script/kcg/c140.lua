--E－HERO ダーク·ガイア
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcFun2(c,aux.FilterBoolFunction(Card.IsSetCard,0x6008),aux.FilterBoolFunction(Card.IsType,TYPE_MONSTER),true)

	-- --lizard check
	-- local e0=Effect.CreateEffect(c)
	-- e0:SetType(EFFECT_TYPE_SINGLE)
	-- e0:SetCode(CARD_CLOCK_LIZARD)
	-- e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	-- e0:SetCondition(s.lizcon)
	-- e0:SetValue(1)
	-- c:RegisterEffect(e0)

	  --spsummon condition
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(s.splimit)
	c:RegisterEffect(e2)

	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(s.atkop)
	c:RegisterEffect(e0)
end

-- function s.lizcon(e,tp,eg,ep,ev,re,r,rp)
-- 	local c=e:GetHandler()
-- 	return not Duel.IsPlayerAffectedByEffect(e:GetHandlerPlayer(),EFFECT_SUPREME_CASTLE)
-- end

function s.splimit(e,se,sp,st)
	return se:GetHandler():IsCode(48130397,23)
end

function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetMaterial()
	if #g<1 then return end
	local exg=g:Filter(Card.IsSetCard,nil,0x6008)
    local exg2=c:GetMaterial()
	exg2:Sub(exg)
	if #exg2~=1 then return end
	local sub=exg2:GetFirst()
	local s=0
	local tc=g:GetFirst()
	while tc do
		local code=tc:GetOriginalCode()
		local att=tc:GetOriginalAttribute()
		local race=tc:GetOriginalRace()
		local a=tc:GetAttack()
		if a<0 then a=0 end
		s=s+a
		if not sub:IsLevelAbove(0) and sub:IsType(TYPE_LINK+TYPE_XYZ) then
			c:CopyEffect(code,RESET_EVENT+EVENT_TO_DECK,1)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_ADD_ATTRIBUTE)
			e1:SetValue(att)  
			e1:SetReset(RESET_EVENT+EVENT_TO_DECK) 
			c:RegisterEffect(e1) 
			local e3=e1:Clone()
			e3:SetCode(EFFECT_ADD_RACE)
			e3:SetValue(race)   
			e3:SetReset(RESET_EVENT+EVENT_TO_DECK)
			c:RegisterEffect(e3) 
		end
		if sub:IsLevelBelow(4) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_ADD_RACE)
			e1:SetValue(att)  
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE) 
			c:RegisterEffect(e1)
		end
		tc=g:GetNext()
	end
	if sub:IsLevelBelow(4) or (not sub:IsLevelAbove(0) and sub:IsType(TYPE_LINK+TYPE_XYZ)) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetValue(s)
		if sub:IsLevelBelow(4) then
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		else
			e1:SetReset(RESET_EVENT+EVENT_TO_DECK)
		end
		c:RegisterEffect(e1)
	end	
	if sub:IsLevelBelow(4) then
		--Pos Change
		local e4=Effect.CreateEffect(c)
		e4:SetCategory(CATEGORY_POSITION)
		e4:SetDescription(aux.Stringid(58332301,0))
		e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
		e4:SetCode(EVENT_ATTACK_ANNOUNCE)
		e4:SetTarget(s.postg)
		e4:SetOperation(s.posop)
		e4:SetReset(RESET_EVENT+EVENT_TO_DECK)
		c:RegisterEffect(e4)
	end
	if sub:IsLevelAbove(5) then
		--Cannot be destroyed
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e5:SetRange(LOCATION_MZONE)
		e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e5:SetValue(1)
		e5:SetReset(RESET_EVENT+EVENT_TO_DECK)
		c:RegisterEffect(e5)
		local e6=e5:Clone()
		e6:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		c:RegisterEffect(e6)
		--Destroy all other monsters
		local e7=Effect.CreateEffect(c)
		e7:SetDescription(aux.Stringid(id,0))
		e7:SetCategory(CATEGORY_DESTROY+CATEGORY_ATKCHANGE)
		e7:SetType(EFFECT_TYPE_IGNITION)
		e7:SetRange(LOCATION_MZONE)
		e7:SetCountLimit(1)
		e7:SetTarget(s.destg)
		e7:SetOperation(s.desop)
		e7:SetReset(RESET_EVENT+EVENT_TO_DECK)
		c:RegisterEffect(e7)
	end
end

function s.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDEFENSEPos,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsDEFENSEPos,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function s.posop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsDEFENSEPos,tp,0,LOCATION_MZONE,nil)
	Duel.ChangePosition(g,0,0,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,true)
end

function s.desfilter(c,atk)
	return c:IsFaceup() and c:IsAttackBelow(atk)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.desfilter,tp,0,LOCATION_MZONE,1,nil,c:GetAttack()) end
	local g=Duel.GetMatchingGroup(s.desfilter,tp,0,LOCATION_MZONE,nil,c:GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local g=Duel.GetMatchingGroup(s.desfilter,tp,0,LOCATION_MZONE,nil,c:GetAttack())
	if Duel.Destroy(g,REASON_EFFECT)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(#(Duel.GetOperatedGroup())*200)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
end