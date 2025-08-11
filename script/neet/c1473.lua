--源影依-神数雅各(neet)
local s,id=GetID()
function s.initial_effect(c)
	--Fusion Materials
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,aux.FilterBoolFunctionEx(Card.IsSetCard,0xc4),aux.FilterBoolFunctionEx(Card.IsSetCard,0x9d))
	Pendulum.AddProcedure(c,false)
	--can't p sum
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(s.penval)
	c:RegisterEffect(e0)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.con)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetDescription(aux.Stringid(id,3))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(s.pencon)
	e2:SetTarget(s.pentg)
	e2:SetOperation(s.penop)
	c:RegisterEffect(e2)
	--Search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,4))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PREDRAW)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCondition(s.thcon)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
end
function s.penfilter(c)
	return not c:IsSetCard(0xc4)
end
function s.penval(e,se,sp,st)
	local tp=e:GetHandler():GetControler()
	return not Duel.IsExistingMatchingCard(s.penfilter,tp,LOCATION_PZONE,0,1,nil) or st&SUMMON_TYPE_FUSION==SUMMON_TYPE_FUSION
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_PENDULUM) or e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--sum
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	e1:SetOperation(s.sumlimit1)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_SPSUMMON_NEGATED)
	e2:SetReset(RESET_PHASE+PHASE_END,2)
	e2:SetOperation(s.sumlimit2)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetTargetRange(0,1)
	e3:SetReset(RESET_PHASE+PHASE_END,2)
	e3:SetCondition(s.econ)
	Duel.RegisterEffect(e3,tp)
	--activate
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EVENT_CHAINING)
	e4:SetReset(RESET_PHASE+PHASE_END,2)
	e4:SetOperation(s.aclimit1)
	Duel.RegisterEffect(e4,tp)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetCode(EVENT_CHAIN_NEGATED)
	e5:SetReset(RESET_PHASE+PHASE_END,2)
	e5:SetOperation(s.aclimit2)
	Duel.RegisterEffect(e5,tp)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_CANNOT_ACTIVATE)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e6:SetDescription(aux.Stringid(id,2))
	e6:SetTargetRange(0,1)
	e6:SetReset(RESET_PHASE+PHASE_END,2)
	e6:SetCondition(s.econ2)
	e6:SetValue(s.elimit)
	Duel.RegisterEffect(e6,tp)
end
function s.sumlimit1(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp then return end
	Duel.RegisterFlagEffect(1-tp,id,RESET_PHASE+PHASE_END,0,2)
end
function s.sumlimit2(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp then return end
	Duel.ResetFlagEffect(1-tp,id)
end
function s.econ(e)
	return Duel.GetFlagEffect(1-e:GetHandlerPlayer(),id)~=0
end
function s.aclimit1(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	Duel.RegisterFlagEffect(1-tp,id+1,RESET_PHASE+PHASE_END,0,2)
end
function s.aclimit2(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	Duel.ResetFlagEffect(1-tp,id+1)
end
function s.econ2(e)
	return Duel.GetFlagEffect(1-e:GetHandlerPlayer(),id+1)~=0
end
function s.elimit(e,te,tp)
	return te:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function s.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function s.penfilter(c,e,tp)
	return c:IsAbleToHand() and c:GetSequence()==0 or c:GetSequence()==4
end
function s.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.penfilter,tp,LOCATION_SZONE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_SZONE)
end
function s.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
	local g=Duel.SelectMatchingCard(tp,s.penfilter,tp,LOCATION_SZONE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	------------------------------------------
	--相关问题没有搞懂 暂时只能用笨办法了
	local zone
	if tc:GetSequence()==0 then zone=0x1 end
	if tc:GetSequence()==4 then zone=0x16 end
	------------------------------------------	
	if tc and Duel.SendtoHand(g,nil,REASON_EFFECT) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true,zone)
	end
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
		and Duel.GetDrawCount(tp)>0
end
function s.filter(c)
	return c:IsSetCard(0x9d) or c:IsSetCard(0xc4) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,3,nil) end
	local dt=Duel.GetDrawCount(tp)
	if dt~=0 then
		_replace_count=0
		_replace_max=dt
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_DRAW_COUNT)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_DRAW)
		e1:SetValue(0)
		Duel.RegisterEffect(e1,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	_replace_count=_replace_count+1
	if _replace_count>_replace_max or not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_DECK,0,nil)
	if #g>=3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,3,3,nil)
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleDeck(tp)
		local tg=sg:RandomSelect(1-tp,1)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
	end
end
