--機皇廠
--Meklord Factory
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

	--Add 1 "Meklord Army" monster to the hand and destroy 1 monster
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
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
s.listed_series={SET_MEKLORD,SET_MEKLORD_ARMY}

function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local bc=Duel.GetAttackTarget()
	return bc:IsSetCard(SET_MEKLORD) and bc:IsFaceup()
end
function s.thfilter(c)
	return c:IsSetCard(SET_MEKLORD_ARMY) and c:IsMonster() and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and s.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,s.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,Duel.GetAttackTarget(),1,tp,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,tc)
		local bc=Duel.GetAttackTarget()
		if bc:IsRelateToBattle() then
			Duel.BreakEffect()
			Duel.Destroy(bc,REASON_EFFECT)
		end
	end
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