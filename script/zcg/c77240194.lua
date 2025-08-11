--奥利哈刚 七武神·水之伤 （ZCG）
function c77240194.initial_effect(c)
	 c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c77240194.spcon)
	c:RegisterEffect(e1)
	--spsummon limit
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e2)
	--to grave
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(77240194,0))
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLE_START)
	e4:SetTarget(c77240194.tgtg)
	e4:SetOperation(c77240194.tgop)
	c:RegisterEffect(e4)
end
function c77240194.tgfilter(c)
return c:IsAttribute(ATTRIBUTE_WATER)
end 
function c77240194.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local d=Duel.GetAttackTarget()
	if chk==0 then return Duel.GetAttacker()==e:GetHandler() and Duel.IsExistingMatchingCard(c77240194.tgfilter,e:GetHandler():GetControler(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,e,tp) end
end
function c77240194.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c77240194.tgfilter,e:GetHandler():GetControler(),LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local atk=g:GetSum(Card.GetAttack)
		if c:IsFaceup() and c:IsRelateToEffect(e) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(atk)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			c:RegisterEffect(e1)
			local g2=Duel.GetMatchingGroup(Card.IsFaceup,e:GetHandler():GetControler(),0,LOCATION_MZONE,nil)   
			if #g2==0 then return end
			local tc=g2:GetFirst()
			while tc do
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetValue(-atk)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			tc:RegisterEffect(e2)
			local e3=e2:Clone()
			e3:SetCode(EFFECT_UPDATE_DEFENSE)
			tc:RegisterEffect(e3)
			if tc:IsAttack(0) or tc:IsDefense(0) then
			Duel.Destroy(tc,REASON_EFFECT) 
			tc=g2:GetNext()
			end
		end
	end 
end
function c77240194.spfilter(c)
return c:IsSetCard(0xa50) and c:IsLevelAbove(5)
end
function c77240194.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c77240194.spfilter,tp,LOCATION_GRAVE,0,7,nil)
end