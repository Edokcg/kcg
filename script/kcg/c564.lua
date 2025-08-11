--奧雷卡爾克斯奇甲之盾星 (KA)
local s, id = GetID()
function s.initial_effect(c)
	Synchro.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x900),1,1,Synchro.NonTunerEx(Card.IsSetCard,0x900),1,99)
	c:EnableReviveLimit()
	
	--immue a
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCondition(s.con)
	e1:SetTarget(s.tfilter)
	e1:SetValue(s.efilter)
	c:RegisterEffect(e1)
	
	--auto be attacked
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ONLY_BE_ATTACKED)
	c:RegisterEffect(e2) 
	
	--DEFENSE up
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(15771991,1))
	e3:SetCategory(CATEGORY_DEFCHANGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BE_BATTLE_TARGET)
	e3:SetCost(s.ducost)
	e3:SetCondition(s.ducon)
	e3:SetOperation(s.duop)
	c:RegisterEffect(e3) 
end
s.listed_series={0x900}
s.material_setcode={0x900}

function s.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsSetCard,1-e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil,0x900)
end
function s.tfilter(e,c)
	return c:IsSetCard(0x900) and c:IsType(TYPE_MONSTER)
end
function s.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end

function s.tfilter(e,c)
	return c:IsSetCard(0x900) and c:IsType(TYPE_MONSTER)
end

function s.ducon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler()==Duel.GetAttackTarget()
end

function s.costfilter(c)
	return c:IsAbleToGraveAsCost()
end

function s.ducost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local cg=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_HAND,0,1,4,nil)
	if #cg<1 then return end
	Duel.SendtoGrave(cg,REASON_COST)
	e:SetLabel(cg:GetCount())
end

function s.duop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cg=e:GetLabel()*600
	if c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(cg)
		c:RegisterEffect(e1)
	end
end
