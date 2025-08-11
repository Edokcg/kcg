--奧雷卡爾克斯眼星 (KA)
local s, id = GetID()
function s.initial_effect(c)
	--synchro summon
	Synchro.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x900),1,1,Synchro.NonTunerEx(Card.IsSetCard,0x900),1,99)
	c:EnableReviveLimit()
	
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(s.adval)
	c:RegisterEffect(e1)  

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(s.con)
	e2:SetTarget(s.tfilter)
	e2:SetValue(s.efilter)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DISABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetCondition(s.con)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_DISABLE_EFFECT)
	c:RegisterEffect(e4)
	
	--Destroy replace
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(327051,1))
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTarget(s.desreptg)
	e5:SetOperation(s.desrepop)
	c:RegisterEffect(e5) 
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
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end

function s.filter(c)
	return c:IsFaceup() and c:GetCode()~=568
end

function s.adval(e,c)
	local g=Duel.GetMatchingGroup(s.filter,e:GetHandlerPlayer(),LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()==0 then 
		return 0
	else
	  local tc=g:GetMaxGroup(Card.GetBaseAttack):GetFirst()
		if tc:GetBaseAttack()<=0 then return 0
		else return tc:GetBaseAttack()*2 end
	end
end

function s.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsDiscardable,tp,LOCATION_HAND,0,nil)
	if chk==0 then return not c:IsReason(REASON_BATTLE) and not c:IsReason(REASON_REPLACE) and c:IsOnField() and g:GetCount()>0 end
	if Duel.SelectYesNo(tp,aux.Stringid(13715,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		local gc=g:Select(tp,1,1,nil)
		local gcs=gc:GetFirst()
		e:SetLabelObject(gcs)
		Duel.HintSelection(gc)
		
		
		return true
	else return false end
end

function s.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoGrave(tc,REASON_EFFECT+REASON_DISCARD)
end

