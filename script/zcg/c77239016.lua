--邪心教义-憎
function c77239016.initial_effect(c)
	--发动效果
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)	
	c:RegisterEffect(e1)
	
    --卡组最上方送墓地
	local e2=Effect.CreateEffect(c)	
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCategory(CATEGORY_DECKDES)
	e2:SetCode(EVENT_PHASE+PHASE_END)	
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c77239016.distg)
	e2:SetOperation(c77239016.disop)
	c:RegisterEffect(e2)
	
	--除外
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetTarget(c77239016.bantg)
	e3:SetOperation(c77239016.banop)
	c:RegisterEffect(e3)
end
---------------------------------------------------------------------
function c77239016.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,1-tp,2)
end
function c77239016.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetControler()~=tp or not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.DiscardDeck(1-tp,2,REASON_EFFECT)
end
---------------------------------------------------------------------
function c77239016.filter(c)
	return c:IsCode(77239016) and c:IsAbleToRemove()
end
function c77239016.bantg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c77239016.filter,tp,LOCATION_GRAVE,0,e:GetHandler(),e:GetHandler():GetCode())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c77239016.banop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c77239016.filter,tp,LOCATION_GRAVE,0,e:GetHandler(),e:GetHandler():GetCode())
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end