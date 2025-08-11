--巨神束缚之矢(neet)
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_ATKCHANGE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,{id,0},EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)	
end
function s.lfilter(c,e)
	return c:IsLinkMonster() and c:IsAttackAbove(800) and not c:IsImmuneToEffect(e)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(s.lfilter,tp,LOCATION_MZONE,0,1,nil,e)
		and Duel.IsExistingTarget(Card.IsNegatableMonster,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local g1=Duel.SelectTarget(tp,s.lfilter,tp,LOCATION_MZONE,0,1,1,nil,e)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	local g2=Duel.SelectTarget(tp,Card.IsNegatableMonster,tp,0,LOCATION_MZONE,1,1,nil)
	e:SetLabelObject(g2:GetFirst())
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,g1,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g2,1,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local hc=e:GetLabelObject()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	if tc==hc then tc=g:GetNext() end
	if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) and hc and hc:IsRelateToEffect(e) and tc:UpdateAttack(-800,RESET_EVENT+RESETS_STANDARD,e:GetHandler())==-800 then
		hc:NegateEffects(e:GetHandler(),0,true)
	end
end