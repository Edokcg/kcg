--邪之创造神(ZCG)
function c77240201.initial_effect(c)
    c:EnableReviveLimit()

    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(c77240201.spcon)
    e1:SetOperation(c77240201.spop)
    c:RegisterEffect(e1)

    --summon
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    c:RegisterEffect(e2)

    --unaffectable
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EFFECT_IMMUNE_EFFECT)
    e3:SetValue(c77240201.efilter)
    c:RegisterEffect(e3)

    --battle indestructable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetValue(1)
	c:RegisterEffect(e4)

    --indes
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e5:SetValue(1)
	c:RegisterEffect(e5)

    --Destroy
	local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(77240201,0))
	e6:SetCategory(CATEGORY_DESTROY)
    e6:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_NEGATE+EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
    e6:SetCountLimit(1)
	e6:SetTarget(c77240201.target)
	e6:SetOperation(c77240201.op1)
	c:RegisterEffect(e6)

    --spsummon
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(77240201,1))
    e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_NEGATE)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTarget(c77240201.tar)
	e7:SetOperation(c77240201.op2)
	c:RegisterEffect(e7)

    --activate spell
	local e8=Effect.CreateEffect(c)
    e8:SetDescription(aux.Stringid(77240201,2))
	e8:SetCategory(CATEGORY_DESTROY)
    e8:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_NEGATE+EFFECT_FLAG_CANNOT_DISABLE)
	e8:SetType(EFFECT_TYPE_IGNITION)
	e8:SetRange(LOCATION_MZONE)
    e8:SetCountLimit(1)
	e8:SetOperation(c77240201.op3)
	c:RegisterEffect(e8)

    --damage
	local e9=Effect.CreateEffect(c)
    e9:SetDescription(aux.Stringid(77240201,3))
	e9:SetCategory(CATEGORY_DESTROY)
    e9:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_NEGATE+EFFECT_FLAG_CANNOT_DISABLE)
	e9:SetType(EFFECT_TYPE_IGNITION)
	e9:SetRange(LOCATION_MZONE)
    e9:SetCountLimit(1)
	e9:SetOperation(c77240201.op4)
	c:RegisterEffect(e9)
end

function c77240201.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end

function c77240201.spop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end

function c77240201.efilter(e,te)
    return te:GetOwner()~=e:GetOwner()
end

function c77240201.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,c) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end

function c77240201.op1(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,e:GetHandler())
	Duel.Destroy(sg,REASON_EFFECT)
	Duel.Recover(tp,sg:GetCount()*1500,REASON_EFFECT)
end

function c77240201.filter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end

function c77240201.tar(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c77240201.filter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end

function c77240201.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c77240201.filter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,3,nil,e,tp)
	local tc=g:GetFirst()
	while tc do
		Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
        tc=g:GetNext()
	end
end

function c77240201.filter1(c,tp,eg,ep,ev,re,r,rp)
	local te=c:GetActivateEffect()
	if not te then return false end
	local condition=te:GetCondition()
	local cost=te:GetCost()
	local target=te:GetTarget()
	return (Duel.GetLocationCount(tp,LOCATION_SZONE)>0 or c:IsType(TYPE_FIELD)) and c:IsType(TYPE_SPELL)
		and (not condition or condition(te,tp,eg,ep,ev,re,r,rp)) and (not cost or cost(te,tp,eg,ep,ev,re,r,rp,0))
		and (not target or target(te,tp,eg,ep,ev,re,r,rp,0))
end

function c77240201.op3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c77240201.filter1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,tp,eg,ep,ev,re,r,rp) then
	local g=Duel.GetMatchingGroup(c77240201.filter1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,tp,eg,ep,ev,re,r,rp)
	local g2=g:Select(tp,1,3,nil)
	local tc=g2:GetFirst()
	local tpe=tc:GetType()
	while tc do
		local te=tc:GetActivateEffect()
		local tep=tc:GetControler()
		local condition=te:GetCondition()
		local cost=te:GetCost()
		Duel.ClearTargetCard()
		local target=te:GetTarget()
		local operation=te:GetOperation()
		e:SetCategory(te:GetCategory())
		e:SetProperty(te:GetProperty())
		Duel.ClearTargetCard()
		if bit.band(tpe,TYPE_FIELD)~=0 then
		   local of=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
		   if of and Duel.Destroy(of,REASON_RULE)==0 then Duel.SendtoGrave(tc,REASON_RULE) end
		end
		local sfloc=LOCATION_SZONE
		if tc:IsType(TYPE_FIELD) then sfloc=LOCATION_FZONE end
		if not Duel.MoveToField(tc,tp,tp,sfloc,POS_FACEUP,true) then return end
		Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
		tc:CreateEffectRelation(te)
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		if target then target(te,tep,eg,ep,ev,re,r,rp,1) end
		local gg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		if gg then
			local etc=gg:GetFirst()
			while etc do
					etc:CreateEffectRelation(te)
				etc=gg:GetNext()
			end
		end
		Duel.BreakEffect()
		if operation then operation(te,tep,eg,ep,ev,re,r,rp) end
		tc:ReleaseEffectRelation(te)
		if etc then
			 etc=gg:GetFirst()
			 while etc do
				 etc:ReleaseEffectRelation(te)
				 etc=gg:GetNext()
			 end
		end
		if not (bit.band(tpe,TYPE_EQUIP+TYPE_CONTINUOUS+TYPE_FIELD)~=0 or tc:IsHasEffect(EFFECT_REMAIN_FIELD)) then
		Duel.SendtoGrave(tc,REASON_RULE) end
        tc=g2:GetNext()
    end
	end
end

function c77240201.op4(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,Duel.GetLP(1-tp),REASON_EFFECT)
end