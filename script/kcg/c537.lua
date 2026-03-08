--インフィニティ・フォース (TF6)
--Infinity Force (TF6)
local s,id=GetID()
function s.initial_effect(c)
	local e4=Effect.GlobalEffect()
	aux.GlobalCheck(s,function()
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_DESTROY)
		e4:SetCondition(s.con)
		e4:SetOperation(s.op4)
		Duel.RegisterEffect(e4,0)
		local e5=Effect.GlobalEffect()
		e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e5:SetCode(EVENT_TURN_END)
		e5:SetCountLimit(1)
		e5:SetLabelObject(e4)
		e5:SetOperation(s.op5)
		Duel.RegisterEffect(e5,0)
	end)

	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_DAMAGE)
	e1:SetCondition(s.descon)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DAMAGE+CATEGORY_TOHAND+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(s.condition)
	e2:SetCost(Cost.SelfBanish)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	e2:SetLabelObject(e4)
	c:RegisterEffect(e2)
end
s.listed_series={SET_MEKLORD}

function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsSetCard,SET_MEKLORD),tp,LOCATION_MZONE,0,1,nil) and ep==tp
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,#sg,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(sg,REASON_EFFECT)
end

function s.con(e,tp,eg,ep,ev,re,r,rp)
	local ag=eg:FilterCount(Card.IsMonster,nil)
	return rp==tp and ag>0
end
function s.op4(e,tp,eg,ep,ev,re,r,rp)
	local ag=eg:FilterCount(Card.IsMonster,nil)
	local count=e:GetLabel()+ag
	e:SetLabel(count)
end
function s.op5(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	local val=te:GetLabel()
	if not val then return end
	te:SetLabel(0)
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local bc=Duel.GetAttackTarget()
	return bc:IsSetCard(SET_MEKLORD) and bc:IsFaceup()
end
function s.thfilter1(c)
	return c:IsMonster() and c:IsSetCard(SET_MEKLORD) and c:IsAbleToHand()
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local te=e:GetLabelObject()
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) 
		and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,#sg,0,0)
	if not te then return end
	local val=te:GetLabel()
	if not val then return end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,val*400)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) 
		and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,0,1,nil)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		if Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
			Duel.ConfirmCards(1-tp,g)
			local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,nil)
			if #sg<1 then return end
			if Duel.Destroy(sg,REASON_EFFECT)<1 then return end
			local te=e:GetLabelObject()
			if not te then return end
			local val=te:GetLabel()
			if not val then return end
			Duel.Damage(1-tp,val*400,REASON_EFFECT)
		end
	end
end