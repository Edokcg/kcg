--宙讀之儀 (KDIY)
local s,id=GetID()
function s.initial_effect(c)
	local e3=Ritual.AddProcEqual{handler=c,filter=s.ritualfil2,lv=8,range=LOCATION_GRAVE,con=aux.exccon,cost=Cost.SelfBanish}
	
	--Activate 1 of these effects
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_RELEASE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(s.efftg)
	e2:SetOperation(s.effop)
	c:RegisterEffect(e2)

	--act qp in hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e0:SetRange(LOCATION_HAND)
	e0:SetTargetRange(LOCATION_HAND,0)
	e0:SetCondition(s.condition)
	c:RegisterEffect(e0)
	
	-- Special Summon
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP + EFFECT_FLAG_DELAY + EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)	
end
s.listed_names = {76794549, 13331639, 56, 55, 446, 160}
s.listed_series = {0x20f8}
-- s.fit_monster = {55, 446, 160}

function s.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local params1={lvtype=RITPROC_GREATER,filter=s.ritualfil1,lv=12,matfilter=s.mritualfil1,forcedselection=s.mgfilter,location=LOCATION_EXTRA}
	local params2={lvtype=RITPROC_EQUAL,filter=s.ritualfil,lv=12,matfilter=s.mritualfil,forcedselection=s.mgfilter,location=LOCATION_EXTRA}
	local b1=Ritual.Target(params1)(e,tp,eg,ep,ev,re,r,rp,0)
	local b2=Ritual.Target(params2)(e,tp,eg,ep,ev,re,r,rp,0)
	if chk==0 then return b1 or b2 end
	local op=Duel.SelectEffect(tp,
			{b1,aux.Stringid(id,1)},
			{b2,aux.Stringid(id,2)})
	e:SetLabel(op)
	if op==1 then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
		Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,tp,LOCATION_HAND|LOCATION_MZONE)
	elseif op==2 then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
		Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,tp,LOCATION_MZONE)
	end
end
function s.effop(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==1 then
		local params1={lvtype=RITPROC_GREATER,filter=s.ritualfil1,lv=12,matfilter=s.mritualfil1,forcedselection=s.mgfilter,location=LOCATION_EXTRA}
		Ritual.Operation(params1)(e,tp,eg,ep,ev,re,r,rp)
	elseif op==2 then
		local params2={lvtype=RITPROC_EQUAL,filter=s.ritualfil,lv=12,matfilter=s.mritualfil,forcedselection=s.mgfilter,location=LOCATION_EXTRA}
		Ritual.Operation(params2)(e,tp,eg,ep,ev,re,r,rp)
	end
end

function s.ritualfil1(c)
	return c:IsCode(446) and c:IsRitualMonster()
end
function s.mritualfil1(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsType(TYPE_PENDULUM)
end
function s.mgfilter(e,tp,sg,sc)
	return Duel.GetLocationCountFromEx(sc:GetControler(),sc:GetControler(),sg,sc)>0
end

function s.ritualfil(c)
	return c:IsCode(55) and c:IsRitualMonster()
end
function s.mritualfil(c)
	return c:IsCode(13331639)
end

function s.ritualfil2(c)
	return c:IsSetCard(0x20f8) and c:IsRitualMonster()
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return tp~=Duel.GetTurnPlayer() 
	and (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
end

function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.spcfilter, 1, nil, e, tp)
end
function s.spcfilter(c, e, tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function s.spcfilterchk(c)
    return c:IsCode(76794549)
end
function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	local c = e:GetHandler()
    if chkc then return s.spcfilterchk(chkc) end
	if chk == 0 then
		return  Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
        and Duel.IsExistingMatchingCard(s.spcfilterchk,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
        and Duel.IsPlayerCanSpecialSummonMonster(tp,56,0x98,TYPES_TOKEN,2500,2000,7,RACE_SPELLCASTER,ATTRIBUTE_DARK)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectMatchingCard(tp,s.spcfilterchk,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #g<1 then return end
    if g:GetFirst():IsLocation(LOCATION_HAND) then Duel.ConfirmCards(1-tp, g) end
    Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.spop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	if not c:IsRelateToEffect(e) or not Duel.GetFirstTarget() or Duel.GetLocationCount(tp,LOCATION_MZONE)<1 or not Duel.IsPlayerCanSpecialSummonMonster(tp,56,0x98,TYPES_TOKEN,2500,2000,7,RACE_SPELLCASTER,ATTRIBUTE_DARK) then
		return
	end
    local token=Duel.CreateToken(tp,56)
	Duel.SpecialSummon(token, 1, tp, tp, false, false, POS_FACEUP)
end
