--原始昆虫 蚊母之卵 LV2(ZCG)
local s,id=GetID()
function s.initial_effect(c)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BATTLE_DESTROYED)
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
function s.efilter(e,te)
	local c=e:GetHandler()
	local ec=te:GetHandler()
	if ec:IsHasCardTarget(c) then return true end
	return te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and c:IsRelateToEffect(te) and ec:GetControler()~=c:GetControler()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ttc=e:GetHandler():GetBattleTarget()
	if chk==0 then return ttc:IsOnField()  and ttc:IsControler(1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,1,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetBattleTarget()
	if tc and tc:IsControler(1-tp)  then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end