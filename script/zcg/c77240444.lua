--原始昆虫 自然搬运工(ZCG)
local s,id=GetID()
function s.initial_effect(c)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(s.con)
	e2:SetTarget(s.target)
	e2:SetOperation(s.activate)
	c:RegisterEffect(e2)
		   --
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCode(EFFECT_IMMUNE_EFFECT)
	e11:SetValue(s.efilter)
	c:RegisterEffect(e11)
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
return Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_HAND,0,nil)<5
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local num=5-Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_HAND,0,nil)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,num) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(num)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,num)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function s.efilter(e,te)
	local c=e:GetHandler()
	local ec=te:GetHandler()
	if ec:IsHasCardTarget(c) then return true end
	return te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and c:IsRelateToEffect(te) and ec:GetControler()~=c:GetControler()
end