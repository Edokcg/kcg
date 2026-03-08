--機限爆弾
--Mektimed Blast
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER|TIMING_END_PHASE)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP + EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCost(s.applycost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(Cost.SelfBanish)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end
s.listed_series={SET_MEKLORD_EMPEROR}

function s.applycost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function s.applyfilter(c)
	return c:IsTrap() and c:ListsArchetype(SET_MEKLORD_EMPEROR) and c:IsAbleToDeckAsCost() and c:IsFaceup() 
	and c:CheckActivateEffect(false,false,false,true)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then 
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(s.applyfilter,tp,LOCATION_REMOVED,0,1,nil)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,s.applyfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()<1 then return end
	Duel.SendtoDeck(g,nil,2,REASON_COST)
	local tc=g:GetFirst()
    Duel.ClearOperationInfo(0)
	local te,ceg,cep,cev,cre,cr,crp=tc:CheckActivateEffect(false,false,true,true)
	local ctp=te:GetHandlerPlayer()
	local cost = te:GetCost()
	local tg = te:GetTarget()
	e:SetDescription(te:GetDescription())
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	tc:CreateEffectRelation(te)
	if cost then cost(te,ctp,ceg,cep,cev,cre,cr,crp,1) end
	if tg then tg(te,ctp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	local gg = Duel.GetChainInfo(0, CHAININFO_TARGET_CARDS)
	if gg then
		local etc = gg:GetFirst()
		while etc do
			etc:CreateEffectRelation(te)
			etc = gg:GetNext()
		end
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	local te=e:GetLabelObject()
	if not te then return end
	local ctp=te:GetHandlerPlayer()
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(te,ctp,eg,ep,ev,re,r,rp) end
	local gg = Duel.GetChainInfo(0, CHAININFO_TARGET_CARDS)
	if gg then
		local etc = gg:GetFirst()
		while etc do
			etc:ReleaseEffectRelation(te)
			etc = gg:GetNext()
		end
	end
end

function s.thfilter(c)
	return c:IsMonster() and c:ListsArchetype(SET_MEKLORD_EMPEROR) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,4,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,4,nil)
	if #g>0 then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
	end
end