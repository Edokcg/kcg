--黑暗的贈禮 (KA)
local s,id=GetID()
function s.initial_effect(c)
	
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(23784496,1))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)

	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_LEAVE_FIELD_P)
	e4:SetOperation(s.checkop)
	c:RegisterEffect(e4)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetLabelObject(e4)
	--e2:SetCondition(s.atcon)
	e2:SetTarget(s.ltarget)
	e2:SetOperation(s.lactivate)
	c:RegisterEffect(e2)
end

function s.dafilter(c)
	return c:IsFaceup() and c:IsSetCard(0x900)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local gc=Duel.GetMatchingGroupCount(s.dafilter,tp,LOCATION_MZONE,0,nil)
		e:SetLabel(gc)
		return gc>0 and Duel.IsPlayerCanDraw(tp,gc)
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(e:GetLabel())
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,e:GetLabel())
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetMatchingGroupCount(s.dafilter,tp,LOCATION_MZONE,0,nil)
	Duel.Draw(p,g,REASON_EFFECT)
end

function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsDisabled() then
		e:SetLabel(1)
	else e:SetLabel(0) end
end
function s.usefilter(c,code)
	return c:IsCode(code) and c:IsFaceup()
end 
function s.atcon(e)
	local tc=Duel.GetFieldCard(e:GetHandler():GetControler(),LOCATION_SZONE,5)
	local tc2=Duel.GetFieldCard(1-e:GetHandler():GetControler(),LOCATION_SZONE,5)
	if tc~=nil and tc:IsFaceup() and tc:IsCode(110000101) and tc2~=nil and tc2:IsFaceup() and tc2:IsCode(110000101) and (Duel.GetTurnCount()==tc:GetTurnID() or Duel.GetTurnCount()==tc2:GetTurnID()) then return false end
	return (tc~=nil and tc:IsFaceup() and tc:IsCode(110000101) and Duel.GetTurnCount()~=tc:GetTurnID())
	or (tc2~=nil and tc2:IsFaceup() and tc2:IsCode(110000101) and Duel.GetTurnCount()~=tc2:GetTurnID())
end
function s.ltarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetLabelObject():GetLabel()==0 and Duel.IsExistingMatchingCard(s.usefilter,tp,LOCATION_SZONE+LOCATION_GRAVE,0,1,nil,110000101)
		and Duel.IsExistingMatchingCard(s.usefilter,tp,LOCATION_SZONE+LOCATION_GRAVE,0,1,nil,110000100)
		and Duel.IsExistingMatchingCard(s.usefilter,tp,LOCATION_SZONE+LOCATION_GRAVE,0,1,nil,48179391)
	end
end
function s.lactivate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (Duel.IsExistingMatchingCard(s.usefilter,tp,LOCATION_SZONE+LOCATION_GRAVE,0,1,nil,110000101)
		and Duel.IsExistingMatchingCard(s.usefilter,tp,LOCATION_SZONE+LOCATION_GRAVE,0,1,nil,110000100)
		and Duel.IsExistingMatchingCard(s.usefilter,tp,LOCATION_SZONE+LOCATION_GRAVE,0,1,nil,48179391)) then return end
	local otoken=Duel.CreateToken(tp,12201)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g1=Duel.SelectMatchingCard(tp,s.usefilter,tp,LOCATION_SZONE+LOCATION_GRAVE,0,1,1,nil,48179391):GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL) 
	local g2=Duel.SelectMatchingCard(tp,s.usefilter,tp,LOCATION_SZONE+LOCATION_GRAVE,0,1,1,nil,110000100):GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL) 
	local g3=Duel.SelectMatchingCard(tp,s.usefilter,tp,LOCATION_SZONE+LOCATION_GRAVE,0,1,1,nil,110000101):GetFirst()
	local g=Group.FromCards(g1,g2,g3)
	if Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_FZONE,0,1,nil,TYPE_FIELD) then
		local otc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
		Duel.Destroy(otc,REASON_RULE)
	end
    if not Duel.MoveToField(otoken,tp,tp,LOCATION_FZONE,POS_FACEUP,true) then return end
	otoken:SetCardData(CARDDATA_TYPE,TYPE_SPELL+TYPE_FIELD) 
	local te,eg,ep,ev,re,r,rp=otoken:CheckActivateEffect(true,true,true)
	local tep=otoken:GetControler()
	local condition=te:GetCondition()
	local cost=te:GetCost()
	Duel.ClearTargetCard()
	local target=te:GetTarget()
	local operation=te:GetOperation()
	Duel.Hint(HINT_CARD,0,12201)
	otoken:CreateEffectRelation(te)
	if cost then cost(e,tep,eg,ep,ev,re,r,rp,1) end
	if target then target(e,tep,eg,ep,ev,re,r,rp,1) end
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
	otoken:ReleaseEffectRelation(te)
	if etc then 
		etc=gg:GetFirst()
		while etc do
			etc:ReleaseEffectRelation(te)
			etc=gg:GetNext()
		end
	end 
	Duel.Overlay(otoken,g)
end