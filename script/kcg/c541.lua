--インフィニティ・ウォール
--Infinity Wall
local s,id=GetID()
function s.initial_effect(c)
	local e4=Effect.GlobalEffect()
	aux.GlobalCheck(s,function()
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_SPSUMMON_SUCCESS)
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

	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.condition)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DAMAGE+CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetLabelObject(e4)
	e2:SetCost(Cost.SelfBanish)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
	
end
s.listed_series={SET_MEKLORD}

function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsSetCard,SET_MEKLORD),tp,LOCATION_MZONE,0,1,nil)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetCondition(s.discon)
	e1:SetOperation(s.disop)
	e1:SetReset(RESET_PHASE|PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.cfilter(c,tp)
	return c:IsOnField() and c:IsControler(tp)
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	if re:IsHasCategory(CATEGORY_NEGATE)
		and Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_EFFECT):IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	return ex and tg~=nil and tc+tg:FilterCount(s.cfilter,nil,tp)-#tg>0
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end

function s.con(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp
end
function s.op4(e,tp,eg,ep,ev,re,r,rp)
	local count=e:GetLabel()+#eg
	e:SetLabel(count)
end
function s.op5(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	local val=te:GetLabel()
	if not val then return end
	te:SetLabel(0)
end

function s.thfilter1(c)
	return c:IsMonster() and c:ListsArchetype(SET_MEKLORD) and c:IsAbleToHand()
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local te=e:GetLabelObject()
	if chk==0 then return te and te:GetLabel() and te:GetLabel()>0 end
	if not te then return end
	local val=te:GetLabel()
	if not val then return end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,val*600)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,val*600)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	local val=te:GetLabel()
	if not val then return end
	Duel.Damage(1-tp,val*600,REASON_EFFECT)
	Duel.Recover(tp,val*600,REASON_EFFECT)
end