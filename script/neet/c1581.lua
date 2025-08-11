--治安战警队 风魔小夜丸
local s,id=GetID()
function s.initial_effect(c)
	--link summon
	Link.AddProcedure(c,s.mfilter,2,2)
	c:EnableReviveLimit()
	--cannot be used as material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetTarget(s.matlimit)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetTarget(s.dislimit)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1581,2))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BATTLE_START)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(s.rmcon)
	e3:SetTarget(s.rmtg)
	e3:SetOperation(s.rmop)
	c:RegisterEffect(e3)
end
function s.matlimit(e,c)
	return c:IsType(TYPE_LINK)
end
function s.disfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x156) and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp)
end
function s.dislimit(e,c)
	local face=c:GetColumnGroup()
	return face:IsExists(s.disfilter,1,nil,e:GetHandlerPlayer())
end
function s.mfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) or c:IsAttribute(ATTRIBUTE_DARK)
end
function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	local bc=Duel.GetAttackTarget()
	if not bc then return false end
	if tc:IsControler(1-tp) then tc,bc=bc,tc end
	if tc:IsFaceup() and tc:IsSetCard(0x156) then
		e:SetLabelObject(bc)
		return true
	else return false end
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local bc=e:GetLabelObject()
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,bc,1,0,0)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local bc=e:GetLabelObject()
	if bc:IsRelateToBattle() then
		Duel.Remove(bc,POS_FACEUP,REASON_EFFECT)
	end
end
