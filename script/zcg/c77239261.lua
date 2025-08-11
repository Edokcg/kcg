--奥利哈刚的结界(ZCG)
function c77239261.initial_effect(c) 
	--发动效果
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_NEGATE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)	
	c:RegisterEffect(e1)

	--删除属性
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EFFECT_REMOVE_ATTRIBUTE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(ATTRIBUTE_EARTH+ATTRIBUTE_WATER+ATTRIBUTE_FIRE+ATTRIBUTE_WIND+ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)
	c:RegisterEffect(e2) 
 
	--攻击提升
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetValue(500)
	c:RegisterEffect(e3)
	
   
   --攻击限制
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(77239261,0))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_FZONE)
	e5:SetTarget(c77239261.attg)
	e5:SetOperation(c77239261.atop)
	c:RegisterEffect(e5)	
	
	--不会被破坏
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_FZONE)
	e6:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e6:SetValue(1)
	c:RegisterEffect(e6)
	
   --
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(77239261,1))
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_NEGATE)
	e7:SetRange(LOCATION_FZONE)
	e7:SetTarget(c77239261.tg1)
	e7:SetOperation(c77239261.op1)
	c:RegisterEffect(e7)

	--
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(77239261,2))
	e8:SetType(EFFECT_TYPE_IGNITION)
	e8:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_NEGATE)
	e8:SetRange(LOCATION_FZONE)
	e8:SetTarget(c77239261.tg2)
	e8:SetOperation(c77239261.op2)
	c:RegisterEffect(e8)
end
---------------------------------------------------------------------------------
function c77239261.filter(c)
	return c:IsFaceup()
end
function c77239261.attg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c77239261.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c77239261.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c77239261.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c77239261.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
		e1:SetRange(LOCATION_MZONE)
		e1:SetTargetRange(0,LOCATION_MZONE)
		e1:SetValue(c77239261.atktg)
		tc:RegisterEffect(e1)
	end
end
function c77239261.atktg(e,c)
	return c~=e:GetHandler()
end
---------------------------------------------------------------------------------
function c77239261.filter1(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c77239261.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c77239261.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c77239261.filter1,tp,LOCATION_MZONE,0,1,nil)
	and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	local g=Duel.SelectTarget(tp,c77239261.filter1,tp,LOCATION_MZONE,0,1,1,nil)
end
function c77239261.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end

function c77239261.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c77239261.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c77239261.filter1,tp,LOCATION_SZONE,0,1,nil)
	and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	local g=Duel.SelectTarget(tp,c77239261.filter1,tp,LOCATION_SZONE,0,1,1,nil)
end
function c77239261.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	Duel.MoveToField(tc,tp,tp,LOCATION_MZONE,POS_FACEUP,true)
end