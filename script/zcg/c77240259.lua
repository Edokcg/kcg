--奥利哈刚 翁尼亚斯 （ZCG）
function c77240259.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_COPY_INHERIT)
	e1:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e1)
  --control
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCode(EFFECT_CANNOT_CHANGE_CONTROL)
	c:RegisterEffect(e0)
  --must attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_MUST_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	c:RegisterEffect(e2)
 --atkup
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(77240259,0))
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(c77240259.atkcost)
	e4:SetOperation(c77240259.atkop)
	c:RegisterEffect(e4)
 --atkup
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(77240259,1))
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCategory(CATEGORY_RECOVER)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCost(c77240259.spcost)
	e5:SetTarget(c77240259.rectg)
	e5:SetOperation(c77240259.recop)
	c:RegisterEffect(e5)
end
function c77240259.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGrave() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c77240259.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local r=e:GetHandler():GetPreviousAttackOnField()
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(r)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,r)
end
function c77240259.recop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end

function c77240259.costfilter(c)
	return c:IsSetCard(0xa50)
end
function c77240259.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c77240259.costfilter,1,e:GetHandler()) end
	local rg=Duel.SelectReleaseGroup(tp,c77240259.costfilter,1,1,e:GetHandler())
	Duel.Release(rg,REASON_COST)
end
function c77240259.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(1000)
	e1:SetReset(RESET_EVENT+RESET_TOFIELD)
	c:RegisterEffect(e1)
end