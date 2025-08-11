--奥利哈刚 七武神·天之惩(ZCG)
local s,id=GetID()
function s.initial_effect(c)
	  c:EnableReviveLimit()
	--special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_HAND)
	e0:SetCondition(s.spcon)
	c:RegisterEffect(e0)
--Activate
	local e99=Effect.CreateEffect(c)
	e99:SetDescription(aux.Stringid(id,0))
	e99:SetType(EFFECT_TYPE_IGNITION)
	e99:SetRange(LOCATION_MZONE)
	e99:SetCountLimit(1)
	e99:SetTarget(s.destg)
	e99:SetOperation(s.desop)
	c:RegisterEffect(e99)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.con)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
	 local e2=e1:Clone()
	e2:SetCode(EVENT_MSET)
	c:RegisterEffect(e2)
	local e5=e1:Clone()
	e5:SetCode(EVENT_SSET)
	c:RegisterEffect(e5)
	local e6=e1:Clone()
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e6)
	local e7=e1:Clone()
	e7:SetCode(EVENT_CHAINING)
	c:RegisterEffect(e7)
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function s.desfilter1(c,rc)
	return c:IsAttribute(rc)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
		Duel.Hint(HINT_SELECTMSG,tp,563)
		local rc=Duel.AnnounceAttribute(tp,1,ATTRIBUTE_ALL-ATTRIBUTE_LIGHT)
		Duel.SetTargetParam(rc)
		e:GetHandler():SetHint(CHINT_ATTRIBUTE,rc)
		local g=Duel.GetMatchingGroup(s.desfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,rc)
		local resatk=0
		local resdes=0
		if #g>0 then
			local tc=g:GetMaxGroup(Card.GetAttack):GetFirst()
			local atk=tc:GetAttack()
			local tc2=g:GetMaxGroup(Card.GetDefense):GetFirst()
			local des=tc2:GetDefense()
			if #g>1 then 
			   local ag=g:Filter(aux.TRUE,tc)
			   if #ag>0 then
				  atk=atk+ag:GetMaxGroup(Card.GetAttack):GetFirst():GetAttack()
			   end
			   local dg=g:Filter(aux.TRUE,tc2)
			 if #dg>0 then
				  des=des+dg:GetMaxGroup(Card.GetDefense):GetFirst():GetDefense()
			   end
			end
			resatk=atk
			resdes=des
		end
	   e:SetLabel(resatk,resdes)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local atk,des=e:GetLabel()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_REPEAT+EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(atk)
	e:GetHandler():RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	e2:SetValue(des)
	e:GetHandler():RegisterEffect(e2)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_REPEAT+EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(200)
	e:GetHandler():RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	e2:SetValue(200)
	e:GetHandler():RegisterEffect(e2)
end
function s.spfilter(c)
	return c:IsSetCard(0xa50) and c:IsLevelAbove(5)
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,7,nil)
end