--聖獣セルケト
local s,id=GetID()
function s.initial_effect(c)
	--selfdestroy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SELF_DESTROY)
	e1:SetCondition(s.descon)
	c:RegisterEffect(e1)
	--redirect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_BATTLE_DESTROY_REDIRECT)
	e2:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e2)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetCondition(s.atkcon)
	e3:SetOperation(s.atkop)
	c:RegisterEffect(e3)
	--Can make a second attack during each Battle Phase, while a Level 10 or higher monster is banished
	-- local e4=Effect.CreateEffect(c)
	-- e4:SetDescription(aux.Stringid(id,1))
	-- e4:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	-- e4:SetType(EFFECT_TYPE_SINGLE)
	-- e4:SetCode(EFFECT_EXTRA_ATTACK)
	-- e4:SetCondition(function(e) return Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsLevelAbove,10),0,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) end)
	-- e4:SetValue(1)
	-- c:RegisterEffect(e4)
end
s.listed_names={29762407}

function s.desfilter(c)
	return c:IsFaceup() and c:IsCode(29762407)
end
function s.descon(e)
	return not Duel.IsExistingMatchingCard(s.desfilter,e:GetHandler():GetControler(),LOCATION_SZONE,0,1,nil)
end
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFaceup() and e:GetHandler():IsRelateToBattle()
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local bc=c:GetBattleTarget()
    if not bc then return end
	local te2={c:IsHasEffect(EFFECT_DOUBLE_TRIBUTE)}
	local double=false
	for _,ae in ipairs(te2) do
		if ae:GetOwner()==c then 
			double=true
			break 
		end
	end
	local te3={c:IsHasEffect(EFFECT_TRIPLE_TRIBUTE)}
	local triple=false
	for _,ae in ipairs(te3) do
		if ae:GetOwner()==c then 
			triple=true
			break 
		end
	end
	local tricount=2
	if double then tricount=3 end
	if triple then tricount=4 end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(bc:GetAttack()/2)
	c:RegisterEffect(e1)
	if tricount>1 then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		if tricount==2 then
			e2:SetCode(EFFECT_DOUBLE_TRIBUTE)
		elseif tricount==3 then
			e2:SetCode(EFFECT_TRIPLE_TRIBUTE)
		end
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e2)
	end
end
