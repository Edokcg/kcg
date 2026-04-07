--ハイドライブ・グラヴィティ
--Hydradrive Gravity
--Scripted by Playmaker 772211, fixed by Larry126
local s,id=GetID()
function s.initial_effect(c)
	--Move
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)

	--Act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(s.handcon)
	c:RegisterEffect(e2)
	
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCost(Cost.SelfBanish)
	e4:SetTarget(s.thtg)
	e4:SetOperation(s.thop)
	c:RegisterEffect(e4)
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp) and Duel.IsExistingMatchingCard(Card.IsLinkMonster,tp,LOCATION_EMZONE,0,1,nil)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local tg=Duel.GetAttacker()
	local zone=aux.GetMMZonesPointedTo(tp,Card.IsLinkMonster,LOCATION_EMZONE,0,1-tp)
	if chk==0 then return zone>0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp,LOCATION_REASON_COUNT,zone)>0
		and tg:IsOnField() and tg:IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(tg)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsControler(tp) or tc:IsImmuneToEffect(e)
		or Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp,LOCATION_REASON_COUNT,zone)==0 then return end
	local zone=aux.GetMMZonesPointedTo(tp,Card.IsLinkMonster,LOCATION_EMZONE,0,1-tp)
	if zone==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	Duel.MoveSequence(tc,math.log(Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,~zone<<16)>>16,2))
end
function s.handcon(e)
	local a=Duel.GetAttacker()
	return a and a:GetAttack()>a:GetBaseAttack()
end

function s.annfilter(c)
	return c:IsFaceup()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.annfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.annfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.annfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local att=Duel.AnnounceAnotherAttribute(g,tp)
	e:SetLabel(att)
end
function s.s.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		--Change its Attribute
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end