--机甲黑暗司令官(neet)
local s,id=GetID()
function s.initial_effect(c)
	--Special Summon procedure
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)   
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(s.target)
	e4:SetValue(s.efilter)
	c:RegisterEffect(e4)
end
s.listed_series={0x36}
function s.cfilter(c,tp)
	return c:IsSetCard(0x36) and c:IsAbleToGraveAsCost()
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,nil)
	return #g>=2 and Duel.GetLocationCount(tp,LOCATION_MZONE)>-2 and aux.SelectUnselectGroup(g,e,tp,2,2,aux.ChkfMMZ(1),0)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local sg=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,nil)
	local g=aux.SelectUnselectGroup(sg,e,tp,2,2,aux.ChkfMMZ(1),1,tp,HINTMSG_TOGRAVE)
	if #g>0 then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	end
	return false
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if not g then return end
	Duel.SendtoGrave(g,REASON_COST)
	g:DeleteGroup()
end
function s.desfilter(c,g)
	return g:IsContains(c)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local cg=e:GetHandler():GetColumnGroup()
	local g=Duel.GetMatchingGroup(s.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler(),cg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
	local dg=g:Filter(Card.IsControler,nil,1-tp)
	if #dg>0 then
		Duel.SetPossibleOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,#dg*500)
		
	end
	local sg=g:Filter(Card.IsControler,nil,tp)
	if #sg>0 then
		Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,#sg,tp,LOCATION_DECK) 
	end
end
function s.thfilter(c)
	return c:IsSetCard(0x36) and c:IsAbleToHand()
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cg=c:GetColumnGroup()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local g=Duel.GetMatchingGroup(s.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c,cg)
		if #g>0 then
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
	local og=Duel.GetOperatedGroup()
	local sg=og:Filter(Card.IsControler,nil,tp)
	if #sg>0 and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,#sg,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local hg=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,#sg,#sg,nil)
		if #hg>0 then
			Duel.SendtoHand(hg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,hg)
		end
	end
	local dg=og:Filter(Card.IsControler,nil,1-tp)
	if #dg>0 then Duel.Damage(1-tp,#dg*500,REASON_EFFECT) end
end
function s.target(e,c)
	return c:IsSetCard(0x36) and c:IsFaceup() and c~=e:GetHandler()
end 
function s.efilter(e,re)
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end