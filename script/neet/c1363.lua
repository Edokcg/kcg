--巨石遗物·图列尔(neet)
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--Link Summon procedure
	Link.AddProcedure(c,nil,2,2,s.lcheck) 
	--Ritual Summon
	local e2=Ritual.CreateProc({handler=c,lvtype=RITPROC_GREATER,filter=s.ritualfil,extrafil=s.extrafil,extraop=s.extraop,matfilter=s.forcedgroup,desc=aux.Stringid(id,0)})
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMING_MAIN_END)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.ritcon)
	c:RegisterEffect(e2)   
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(aux.zptcon(s.spcfilter))
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
end
s.listed_series={0x138}
function s.spcfilter(c)
	return c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_RITUAL)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end

function s.ritcon()
	return Duel.IsMainPhase()
end
function s.lcheck(g,lc,sumtype,tp)
	return g:IsExists(Card.IsType,1,nil,TYPE_RITUAL,lc,sumtype,tp)
end
function s.extrafil(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
end
function s.extraop(mat,e,tp,eg,ep,ev,re,r,rp,tc)
	return Duel.Release(mat,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
end
function s.forcedgroup(c,e,tp)
	return  c:IsFaceup() and c:IsLocation(LOCATION_ONFIELD) and c:IsType(TYPE_MONSTER) and c:IsCanBeRitualMaterial()
end
function s.ritualfil(c)
	return c:IsSetCard(0x138) and c:IsRitualMonster()
end